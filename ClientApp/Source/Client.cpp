// MIT License
//
// Copyright (c) 2025 Oleksandr
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include "Client.h"
#include "Common/Serializer.h"

#include <spdlog/spdlog.h>
#include <fstream>

Client::Client(QObject* parent) : QObject(parent), _socket{ _ioContext }
{
    _workGuard.emplace(boost::asio::make_work_guard(_ioContext));
}

void Client::connect()
{
    try
    {
        spdlog::info("Connecting to server...");
        boost::asio::ip::tcp::resolver resolver(_ioContext);
        auto endpoints = resolver.resolve(_host, _port);
        boost::asio::connect(_socket, endpoints);
        _isConnected = true;

        spdlog::info("Successfully connected to server.");
        startReceiving();

        if (!_ioThread.has_value())
        {
            _ioThread.emplace(
                [this]()
                {
                    try
                    {
                        _ioContext.run();
                    }
                    catch (const std::exception& e)
                    {
                        spdlog::error("io_context exception: {}", e.what());
                    }
                });
        }
    }
    catch (const boost::system::system_error& e)
    {
        spdlog::error("Failed to connect to server: {}", e.what());
    }
}

void Client::disconnect()
{
    _isConnected = false;

    boost::system::error_code ec;
    _socket.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ec);
    _socket.close(ec);

    if (_workGuard.has_value())
    {
        _workGuard->reset();
        _workGuard.reset();
    }

    if (_ioThread.has_value() && _ioThread->joinable())
    {
        _ioThread->join();
        _ioThread.reset();
    }

    spdlog::info("Disconnected from server.");
}

void Client::registerClient()
{
    const nlohmann::json msg = { { "type", "REGISTER" }, { "sender", _senderName } };
    sendJson(msg);

    spdlog::info("Registered client: {}", _senderName);
}

void Client::startReceiving()
{
    if (!_isConnected)
        return;

    boost::asio::async_read(_socket, boost::asio::buffer(&_incomingLength, sizeof(_incomingLength)),
                            [this](boost::system::error_code ec, std::size_t)
                            {
                                if (!_isConnected || ec == boost::asio::error::operation_aborted)
                                {
                                    spdlog::warn("Receive operation aborted.");
                                    return;
                                }

                                if (ec)
                                {
                                    spdlog::error("Read length error: {}", ec.message());
                                    return;
                                }

                                if (_incomingLength > 10 * 1024 * 1024)
                                {
                                    spdlog::warn("Incoming message too large: {} bytes",
                                                 _incomingLength);
                                    _incomingLength = 0;
                                    startReceiving();
                                    return;
                                }

                                _incomingData.resize(_incomingLength);
                                readMessageData();
                            });
}

void Client::sendText(const QString& receiver, const QString& message)
{
    const auto stdMessage = message.toStdString();
    const auto stdReceiver = receiver.toStdString();
    const std::string encoded
        = Serializer::serializeBase64({ stdMessage.begin(), stdMessage.end() });
    const nlohmann::json msg = { { "sender", _senderName },
                                 { "receiver", stdReceiver },
                                 { "type", "TEXT" },
                                 { "data", encoded } };

    sendJson(msg);
    spdlog::info("Sending message");
}

void Client::sendFile(const QString& receiver, const QString& filename)
{
    spdlog::info("Sending file: {}", filename.toStdString());
    const std::string stdFilename = filename.toStdString();
    std::ifstream file(stdFilename, std::ios::binary);
    if (!file)
    {
        spdlog::error("File not found: {}", filename.toStdString());
        return;
    }

    std::vector<unsigned char> file_data((std::istreambuf_iterator<char>(file)),
                                         std::istreambuf_iterator<char>());
    std::string encoded = Serializer::serializeBase64(file_data);

    nlohmann::json msg = { { "sender", _senderName },
                           { "receiver", receiver.toStdString() },
                           { "type", "FILE" },
                           { "filename", filename.toStdString() },
                           { "data", encoded } };

    sendJson(msg);
}

void Client::sendJson(const nlohmann::json& j)
{
    const std::string serialized = j.dump();
    const uint32_t len = serialized.size();
    boost::asio::write(_socket, boost::asio::buffer(&len, sizeof(len)));
    boost::asio::write(_socket, boost::asio::buffer(serialized));
    spdlog::info("Sent {} bytes", len);
}

void Client::readMessageData()
{
    if (!_isConnected)
        return;

    boost::asio::async_read(_socket, boost::asio::buffer(_incomingData),
                            [this](boost::system::error_code ec, std::size_t)
                            {
                                if (!_isConnected || ec == boost::asio::error::operation_aborted)
                                {
                                    spdlog::warn("Read aborted.");
                                    return;
                                }

                                if (ec)
                                {
                                    spdlog::error("Read message error: {}", ec.message());
                                    return;
                                }

                                std::string json_text(reinterpret_cast<char*>(_incomingData.data()),
                                                      _incomingData.size());
                                spdlog::info("RAW JSON: {}", json_text);

                                handleIncomingJson(json_text);
                                startReceiving();
                            });
}

void Client::handleIncomingJson(const std::string& jsonText)
{
    try
    {
        nlohmann::json msg = nlohmann::json::parse(jsonText);
        std::string type = msg["type"];
        std::string sender = msg.value("sender", "unknown");

        spdlog::info("Start handle message type: {}", type);

        if (type == "TEXT")
        {
            handleTextMessage(msg, sender);
        }
        else if (type == "FILE")
        {
            handleFileMessage(msg, sender);
        }
        else
        {
            spdlog::warn("Unknown message type: {}", type);
        }
    }
    catch (const std::exception& e)
    {
        spdlog::error("Failed to parse message: {}", e.what());
    }
}

void Client::handleTextMessage(const nlohmann::json& msg, const std::string& sender)
{
    spdlog::info("Incoming TEXT type message");
    std::string encoded = msg["data"];
    std::vector<unsigned char> decoded = Serializer::deserializeBase64(encoded);
    std::string message(decoded.begin(), decoded.end());
    spdlog::info("[from {}]: {}", sender, message);

    const QString qSender = QString::fromStdString(sender);
    const QString qMessage = QString::fromStdString(message);
    emit receivedTextMessage(qSender, qMessage);
}

void Client::handleFileMessage(const nlohmann::json& msg, const std::string& sender) {}
