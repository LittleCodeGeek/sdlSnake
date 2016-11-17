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

ExternalProject_Add(
    extSDL
    PREFIX "extra"
    GIT_REPOSITORY "https://github.com/SDL-mirror/SDL.git"
    GIT_TAG "release-2.0.5"
    UPDATE_COMMAND ""
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
)
ExternalProject_Get_Property(extSDL install_dir)
set(SDL_INSTALL_DIR ${install_dir})
ExternalProject_Get_Property(extSDL source_dir)
set(SDL_INCLUDE_DIRS "${source_dir}/include")
set(SDL_LIB ${SDL_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}SDL2${CMAKE_STATIC_LIBRARY_SUFFIX})
set(SDL_MAIN_LIB ${SDL_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}SDL2main${CMAKE_STATIC_LIBRARY_SUFFIX})

add_library(SDL STATIC IMPORTED)
set_target_properties(SDL PROPERTIES IMPORTED_LOCATION ${SDL_LIB})
add_library(SDLmain STATIC IMPORTED)
set_target_properties(SDLmain PROPERTIES IMPORTED_LOCATION ${SDL_MAIN_LIB})

if (WIN32)
    set(base_libs ${base_libs} winmm.lib Imm32.lib version.lib)
endif()

if (UNIX AND APPLE)
    find_library(COCOA_LIBRARY cocoa)
    find_library(CARBON_LIBRARY carbon)
    find_library(COREAUDIO_LIBRARY coreaudio)
    find_library(AUDIOTOOLBOX_LIBRARY audiotoolbox)
    find_library(FORCEFEEDBACK_LIBRARY forcefeedback)
    find_library(COREVIDEO_LIBRARY corevideo)
    find_library(IOKIT_LIBRARY iokit)
    find_library(ICONV_LIBRARY iconv)
    set(base_libs ${base_libs} ${COCOA_LIBRARY} ${CARBON_LIBRARY} ${COREAUDIO_LIBRARY} ${AUDIOTOOLBOX_LIBRARY} ${FORCEFEEDBACK_LIBRARY} ${COREVIDEO_LIBRARY} ${IOKIT_LIBRARY} ${ICONV_LIBRARY})
endif()

add_subdirectory(main)
