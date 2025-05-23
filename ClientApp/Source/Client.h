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

#pragma once

#include <boost/asio.hpp>
#include <nlohmann/json.hpp>

#include <QObject>

class Client final : public QObject
{
    Q_OBJECT
public:
    Client(QObject* parent = nullptr);
    ~Client() { disconnect(); }

    void run() { _ioContext.run(); }

signals:
    void receivedTextMessage(const QString& sender, const QString& msg);

public slots:
    void connect();
    void startReceiving();
    void registerClient();
    void setName(const QString& name) { _senderName = name.toStdString(); }
    void sendText(const QString& receiver, const QString& message);
    void sendFile(const QString& receiver, const QString& filename);

    [[nodiscard]] QString getClientName() const { return _senderName.data(); }

private:
    void disconnect();
    void sendJson(const nlohmann::json& j);

    void readMessageData();
    void handleIncomingJson(const std::string& jsonText);
    void handleTextMessage(const nlohmann::json& msg, const std::string& sender);
    void handleFileMessage(const nlohmann::json& msg, const std::string& sender);

private:
    const std::string _port{ "8080" };
    const std::string _host{ "127.0.0.1" };

    bool _isConnected{ false };
    std::string _senderName{ "unnamed" };

    uint32_t _incomingLength{};
    boost::asio::io_context _ioContext;
    boost::asio::ip::tcp::socket _socket;
    std::vector<unsigned char> _incomingData;

    std::optional<boost::asio::executor_work_guard<boost::asio::io_context::executor_type>>
        _workGuard;
    std::optional<std::thread> _ioThread;
};
