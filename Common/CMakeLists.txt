file(
        GLOB Sources
        "*.h"
        "*.cpp"
)

add_library(Common STATIC ${Sources})

target_include_directories(Common PUBLIC ../)

target_link_libraries(Common PUBLIC)