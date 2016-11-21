cmake_minimum_required(VERSION 3.4)
project(main)

set(SOURCES
    main.cpp
    snakegame.cpp
)

add_executable(sdlSnake ${SOURCES})
target_link_libraries(sdlSnake SDL SDLmain SDL_image)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD 14)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD_REQUIRED ON)

install(
    TARGETS sdlSnake
    COMPONENT "Runtime"
    RUNTIME DESTINATION "${CMAKE_SOURCE_DIR}/bin"
)
