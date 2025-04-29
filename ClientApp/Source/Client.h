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

#include "spdlog/spdlog.h"

#include <boost/asio.hpp>
#include <nlohmann/json.hpp>

#include <QObject>

class Client final : public QObject
{
    Q_OBJECT
public:
    Client(QObject* parent = nullptr);

    void run() { _ioContext.run(); }

public slots:
    void connect();
    void startReceiving();
    void registerClient();
    void setName(const QString& name) { _senderName = name.toStdString(); }
    void sendText(const std::string& receiver, const std::string& message);
    void sendFile(const std::string& receiver, const std::string& filename);

private:
    void sendJson(const nlohmann::json& j);

private:
    const std::string _port{ "8080" };
    const std::string _host{ "127.0.0.1" };

    uint32_t _incomingLength{};
    boost::asio::io_context _ioContext;
    boost::asio::ip::tcp::socket _socket;
    std::vector<unsigned char> _incomingData;
    std::string _senderName{ "unnamed" };
};
