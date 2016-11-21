cmake_minimum_required(VERSION 3.4)
project(sdlSnake)
find_package(Git)

add_custom_target(submodule_init
    COMMAND ${GIT_EXECUTABLE} submodule init
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_target(sdl_submodule
    COMMAND ${GIT_EXECUTABLE} submodule update -- extra/SDL
    DEPENDS submodule_init
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_subdirectory(src)
