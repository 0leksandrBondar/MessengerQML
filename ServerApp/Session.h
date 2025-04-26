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

#include "Server.h"

#include <boost/asio.hpp>

class Session : public std::enable_shared_from_this<Session>
{
public:
    Session(boost::asio::ip::tcp::socket socket, Server& server);

    void start();

private:
    void readHeader();
    void readBody();

    void sendRaw(const std::string& data);

    void handleMessage(const std::string& json_text);
    void processFile(const std::string& sender, const std::string& receiver,
                     const std::string& filename_raw, const std::vector<unsigned char>& data);
    void processText(const std::string& sender, const std::string& receiver,
                     const std::string& message);

    std::string sanitizeFilename(std::string filename);

    // TEST
    std::string getDesktopPath();

private:
    Server& _server;
    uint32_t _dataLen = 0;
    std::vector<char> _data;
    std::string _clientName;
    boost::asio::ip::tcp::socket _socket;
};