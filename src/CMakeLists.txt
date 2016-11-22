cmake_minimum_required(VERSION 3.4)

include(ExternalProject)

# precompiled header macro
macro(ADD_PRECOMPILED_HEADER PrecompiledHeader SourcesVar)
if(MSVC)
    get_filename_component(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
    get_source_file_property(PrecompiledPath ${PrecompiledHeader} LOCATION)
    get_filename_component(PrecompiledPath ${PrecompiledPath} PATH)
    set(PrecompiledSource "${CMAKE_CURRENT_BINARY_DIR}/gen/${PrecompiledBasename}.cpp")
    set(${SourcesVar}
        ${${SourcesVar}}
        ${PrecompiledSource})
    set_source_files_properties(${PrecompiledSource} PROPERTIES
        COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /I\"${PrecompiledPath}\" /I\"%(AdditionalIncludeDirectories)\""
        GENERATED 1)
    source_group(Generated FILES ${PrecompiledSource})
    file(WRITE ${PrecompiledSource} "#include \"${PrecompiledHeader}\"\n")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Yu\"${PrecompiledHeader}\" /FI\"${PrecompiledHeader}\"")
endif(MSVC)
endmacro(ADD_PRECOMPILED_HEADER)

if (WIN32)
    add_library(SDL STATIC IMPORTED)
    add_library(SDLmain STATIC IMPORTED)
    add_library(SDL_image STATIC IMPORTED)

    file(DOWNLOAD "https://www.libsdl.org/release/SDL2-devel-2.0.5-VC.zip"
        "${CMAKE_CURRENT_BINARY_DIR}/sdl2.zip"
        EXPECTED_HASH SHA256=5af6a1a0f19a297c107489f271d61f96257aae3fdceae8515ead8311cfac0711
    )
    file(DOWNLOAD "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.1-VC.zip"
        "${CMAKE_CURRENT_BINARY_DIR}/sdl2image.zip"
        EXPECTED_HASH SHA256=adf6b1247960cd0fcea2ba2a70eb30bbdcf43ee246f78cf1bcccd1111305b451
    )
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xZf sdl2.zip
        COMMAND ${CMAKE_COMMAND} -E tar xZf sdl2image.zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    set_target_properties(SDL PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2-2.0.5/lib/x64/SDL2.lib
    )
    set_target_properties(SDL PROPERTIES INTERFACE_LINK_LIBRARIES
        "winmm.lib;Imm32.lib;version.lib"
    )
    set_target_properties(SDL PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2-2.0.5/include
    )
    set_target_properties(SDLmain PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2-2.0.5/lib/x64/SDL2main.lib
    )
    set_target_properties(SDL_image PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/SDL2_image.lib
    )
    set_target_properties(SDL_image PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/include
    )
    set(sdl_dep_libs
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2-2.0.5/lib/x64/SDL2.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/SDL2_image.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/libjpeg-9.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/libpng16-16.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/libtiff-5.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/libwebp-4.dll
        ${CMAKE_CURRENT_BINARY_DIR}/SDL2_image-2.0.1/lib/x64/zlib1.dll
    )
    install(
        FILES ${sdl_dep_libs}
        COMPONENT "Runtime"
        DESTINATION "${CMAKE_SOURCE_DIR}/bin"
    )
else()
    add_library(SDL STATIC IMPORTED)
    add_library(SDLmain STATIC IMPORTED)
    add_library(SDL_image STATIC IMPORTED)
    
    if (UNIX AND APPLE)
        find_program(BREW brew)
        if (NOT BREW)
            message(FATAL_ERROR "Brew was not found, cannot proceed on Mac OS without brew")
        endif()

        if (NOT DEFINED ${NEED_INSTALL_SDL} OR ${NEED_INSTALL_SDL})
            execute_process(
                COMMAND sh -c "if ! ${BREW} ls --versions sdl2 >/dev/null; then ${BREW} install sdl2; fi;"
            )
            execute_process(
                COMMAND sh -c "if ! ${BREW} ls --version sdl2_image >/dev/null; then ${BREW} install sdl2_image; fi;"
            )
            set(NEED_INSTALL_SDL OFF CACHE BOOL "Do we need to install SDL with a package manager")
        endif()
    endif()

    INCLUDE(FindPkgConfig)

    PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2>=2.0.5)
    PKG_SEARCH_MODULE(SDL2IMAGE REQUIRED SDL2_image>=2.0.1)

    set_target_properties(SDL PROPERTIES IMPORTED_LOCATION
        ${SDL2_STATIC_LIBRARY_DIRS}/${CMAKE_STATIC_LIBRARY_PREFIX}SDL2${CMAKE_STATIC_LIBRARY_SUFFIX}
    )
    set_target_properties(SDL PROPERTIES INTERFACE_LINK_LIBRARIES
        "${SDL2_STATIC_LDFLAGS}"
    )
    set_target_properties(SDL PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
        ${SDL2_INCLUDE_DIRS}
    )
    set_target_properties(SDLmain PROPERTIES IMPORTED_LOCATION
        ${SDL2_STATIC_LIBRARY_DIRS}/${CMAKE_STATIC_LIBRARY_PREFIX}SDL2main${CMAKE_STATIC_LIBRARY_SUFFIX}
    )
    set_target_properties(SDL_image PROPERTIES IMPORTED_LOCATION
        ${SDL2IMAGE_STATIC_LIBRARY_DIRS}/${CMAKE_STATIC_LIBRARY_PREFIX}SDL2_image${CMAKE_STATIC_LIBRARY_SUFFIX}
    )
endif()

add_subdirectory(main)
