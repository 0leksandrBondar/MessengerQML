cmake_minimum_required(VERSION 3.16...3.29)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

project(Server)

file(GLOB SOURCES
        "*.h"
        "*.cpp")

add_executable(${PROJECT_NAME} ${SOURCES})

target_link_libraries(${PROJECT_NAME} PUBLIC
        Qt
        Common
        Boost::asio
        spdlog::spdlog
        nlohmann_json::nlohmann_json
)