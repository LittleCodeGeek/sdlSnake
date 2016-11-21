cmake_minimum_required(VERSION 3.4)

include_directories(${SDL_INCLUDE_DIRS})

set(SOURCES
    main.cpp
    snakegame.cpp
)

add_executable(sdlSnake ${SOURCES})
target_link_libraries(sdlSnake SDL SDLmain SDL_image ${base_libs})
add_dependencies(sdlSnake extSDL extSDL_image)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD 14)
set_property(TARGET sdlSnake PROPERTY CXX_STANDARD_REQUIRED ON)

install(
    TARGETS sdlSnake
    RUNTIME DESTINATION "${CMAKE_SOURCE_DIR}/bin"
)
