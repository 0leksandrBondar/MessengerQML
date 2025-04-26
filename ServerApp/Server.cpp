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

#include "Server.h"
#include <spdlog/spdlog.h>

#include "Session.h"

Server::Server(boost::asio::io_context& io_context, short port)
    : _acceptor{ io_context, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port) }
{
    accept();
}

void Server::registerClient(const std::string& name, std::shared_ptr<Session> session)
{
    std::lock_guard<std::mutex> lock(_mutex);
    _clients[name] = session;
    spdlog::info("Registered client: {}", name);
}

void Server::unregisterClient(const std::string& name)
{
    std::lock_guard<std::mutex> lock(_mutex);
    _clients.erase(name);
    spdlog::info("Unregistered client: {}", name);
}

std::shared_ptr<Session> Server::getClientSession(const std::string& name)
{
    std::lock_guard<std::mutex> lock(_mutex);
    auto it = _clients.find(name);
    return it != _clients.end() ? it->second : nullptr;
}

void Server::accept()
{
    _acceptor.async_accept(
        [this](boost::system::error_code ec, boost::asio::ip::tcp::socket socket)
        {
            if (!ec)
            {
                std::make_shared<Session>(std::move(socket), *this)->start();
            }
            accept();
        });
}
