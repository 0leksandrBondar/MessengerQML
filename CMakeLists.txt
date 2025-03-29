cmake_minimum_required(VERSION 3.16)

project(Messenger)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QML_CONTENT_PATH ${CMAKE_SOURCE_DIR}/App/QMLContent/qml_content.qrc)

add_subdirectory(App)
add_subdirectory(Dependencies)

