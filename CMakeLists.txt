cmake_minimum_required(VERSION 3.4)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "Prevented in-tree built. Please create a build directory outside of the source code and call cmake from there")
endif()

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

add_custom_target(sdl_image_submodule
    COMMAND ${GIT_EXECUTABLE} submodule update -- extra/SDL_image
    DEPENDS submodule_init
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_subdirectory(src)
