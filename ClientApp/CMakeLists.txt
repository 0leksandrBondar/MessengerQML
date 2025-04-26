set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

file(GLOB SOURCES
        "Source/*.h"
        "Source/*.cpp")

set(QML_SOURCES ${QML_CONTENT_PATH})

add_executable(${PROJECT_NAME} ${SOURCES} ${QML_SOURCES})

target_link_libraries(${PROJECT_NAME}
        Qt
        Common
        Boost::asio
        spdlog::spdlog
        nlohmann_json::nlohmann_json
)
