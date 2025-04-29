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

Client::Client(QObject* parent) : QObject(parent), _socket{ _ioContext } {}

void Client::connect()
{
    try
    {
        spdlog::info("Connecting to server...");
        boost::asio::ip::tcp::resolver resolver(_ioContext);
        auto endpoints = resolver.resolve(_host, _port);
        boost::asio::connect(_socket, endpoints);
        spdlog::info("Successfully connected to server.");
    }
    catch (const boost::system::system_error& e)
    {
        spdlog::error("Failed to connect to server: {}", e.what());
    }
}

void Client::registerClient()
{
    const nlohmann::json msg = { { "type", "REGISTER" }, { "sender", _senderName } };
    sendJson(msg);
}

void Client::startReceiving()
{
    spdlog::info("Start receiving");
    // TODO: implement this
}

void Client::sendText(const std::string& receiver, const std::string& message)
{
    const std::string encoded = Serializer::serializeBase64({ message.begin(), message.end() });
    const nlohmann::json msg = {
        { "sender", _senderName }, { "receiver", receiver }, { "type", "TEXT" }, { "data", encoded }
    };

    sendJson(msg);
}

void Client::sendFile(const std::string& receiver, const std::string& filename)
{
    // TODO: implement this
}

void Client::sendJson(const nlohmann::json& j)
{
    const std::string serialized = j.dump();
    const uint32_t len = serialized.size();
    boost::asio::write(_socket, boost::asio::buffer(&len, sizeof(len)));
    boost::asio::write(_socket, boost::asio::buffer(serialized));
    spdlog::info("Sent {} bytes", len);
}