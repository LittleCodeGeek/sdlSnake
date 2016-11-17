cmake_minimum_required(VERSION 3.4)

project(sdlSnake)

include_directories(${SDL_INCLUDE_DIRS})

set(SOURCES
    main.cpp
)

add_executable(sdlSnake ${SOURCES})
target_link_libraries(sdlSnake SDL SDLmain ${base_libs})
add_dependencies(sdlSnake extSDL)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD 14)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD_REQUIRED ON)
