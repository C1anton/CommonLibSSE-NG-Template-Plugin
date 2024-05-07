########################################################################################################################
## Main CMake Project Setup
########################################################################################################################

# It's recommended to set a minimum CMake version.
# If you use CMake features from higher versions, update this to match.
cmake_minimum_required(VERSION 3.21)

# Set your project name by replacing TemplatePlugin. This will be the name of your SKSE .dll file.
# Note: Does not support spaces or periods. Keep it simple but identifiable and unique.
project(
    TemplatePlugin 
    VERSION 0.0.1 
    LANGUAGES CXX
)

########################################################################################################################
## Advanced CMake Configuration & Libraries (Intermediate users only)
## author: colorglass, Monitor144hz, Skyrim Scripting
########################################################################################################################

# Define compiler version.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

# Used by some included libraries.
include(GNUInstallDirs)

# Set default .dll output to "/build/SKSE/Plugins"
set(OUTPUT_FOLDER "${CMAKE_SOURCE_DIR}/build")

# Using "SKYRIM_MODS_FOLDER" ENV variable since it's common across multiple templates.
# The folder structure will be created if it doesn't exist, so you don't need to create an empty mod.
# This setting will output the .dll and .pdb file into:

# {SKYRIM_MODS_FOLDER}/{PROJECT NAME} DEBUG or RELEASE/SKSE/Plugins/TemplatePlugin.dll
# {SKYRIM_MODS_FOLDER}/{PROJECT NAME} DEBUG or RELEASE/SKSE/Plugins/TemplatePlugin.pdb
if(DEFINED ENV{SKYRIM_MODS_FOLDER} AND IS_DIRECTORY "$ENV{SKYRIM_MODS_FOLDER}")
    set(OUTPUT_FOLDER "$ENV{SKYRIM_MODS_FOLDER}/${PROJECT_NAME} ${CMAKE_BUILD_TYPE}")
endif()

# Otherwise, you can set OUTPUT_FOLDER to any place you'd like by uncommenting this line.
# set(OUTPUT_FOLDER "C:/path/to/any/folder")

# Find and build dependencies of/for CommonLibSSE
find_package(CommonLibSSE CONFIG REQUIRED)
find_path(ARTICUNO_INCLUDE_DIRS "articuno/articuno.h")
find_package(ryml CONFIG REQUIRED)

# Add any .cpp, .h, or .cpp test files to the appropriate .cmake files below.
include(cmake/headerlist.cmake)
include(cmake/sourcelist.cmake)
include(cmake/tests.cmake)

# CommonLibeSSE-NG feature required for ng deployment
add_commonlibsse_plugin(${PROJECT_NAME} SOURCES ${headers} ${sources}) #    <--- specifies plugin.cpp
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23) #               <--- use C++23 standard

# Setup linked libraries for library dependencies specified in vcpkg-configuration.
target_include_directories(
    "${PROJECT_NAME}"
    PRIVATE
        ${SIMPLEINI_INCLUDE_DIRS}
        ${ARTICUNO_INCLUDE_DIRS}
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
        ryml::ryml
)

# Do not touch this line.
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h) # <--- PCH.h is required!


install(
    TARGETS 
    ${PROJECT_NAME}
    DESTINATION 
    "${CMAKE_INSTALL_LIBDIR}"
)

########################################################################################################################
## Catch2 conditonal unit test Cmake configuration (Advanced users only)
## author: colorglass
## src: https://gitlab.com/colorglass/commonlibsse-sample-plugin
## catch2: https://github.com/catchorg/Catch2
########################################################################################################################

message("Options:")
option(BUILD_TESTS "Build unit tests." OFF)
message("\tTests: ${BUILD_TESTS}")

if(BUILD_TESTS)
    find_package(Catch2 CONFIG REQUIRED)

    include(CTest)
    include(Catch)

    add_executable(
            ${PROJECT_NAME}Tests
            ${headers}
            ${tests})

    target_link_libraries(
            ${PROJECT_NAME}Tests
            PRIVATE
            ${PROJECT_NAME}
            Catch2::Catch2WithMain)

    target_precompile_headers(${PROJECT_NAME}Tests
            PRIVATE
            src/PCH.h)

    catch_discover_tests(${PROJECT_NAME}Tests)
    add_test(NAME ${PROJECT_NAME}Tests COMMAND ${PROJECT_NAME}Tests)
    message("Build Test Unit Complete: ${PROJECT_NAME}Tests")
endif()

########################################################################################################################
## CMake Output Configuration (Advanced Users Only)
## author: Monitor144hz
## src: https://github.com/Monitor144hz/CommonLibSSE-NG-Template-Plugin
########################################################################################################################


# When your SKSE .dll is compiled, this will automatically copy the .dll into your mods folder.
# Only works if you configure OUTPUT_FOLDER above (or set the SKYRIM_MODS_FOLDER environment variable)
if(DEFINED OUTPUT_FOLDER)
    # If you specify an <OUTPUT_FOLDER> (including via environment variables)
    # then we'll copy your mod files into Skyrim or a mod manager for you!

    # Copy the SKSE plugin .dll files into the SKSE/Plugins/ folder
    set(DLL_FOLDER "${OUTPUT_FOLDER}/SKSE/Plugins")

    message(STATUS "SKSE plugin output folder: ${DLL_FOLDER}")

    add_custom_command(
        TARGET "${PROJECT_NAME}"
        POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${DLL_FOLDER}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PROJECT_NAME}>" "${DLL_FOLDER}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
        VERBATIM
    )

    # If you perform a "Debug" build, also copy .pdb file (for debug symbols)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        add_custom_command(
            TARGET "${PROJECT_NAME}"
            POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${PROJECT_NAME}>" "${DLL_FOLDER}/$<TARGET_PDB_FILE_NAME:${PROJECT_NAME}>"
            VERBATIM
        )
    endif()
endif()
