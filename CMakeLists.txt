#
# -~-~-~-~-~-              Project Setup                -~-~-~-~-~-
#
cmake_minimum_required(VERSION 3.21)

project(
    TemplatePlugin 
    VERSION 0.0.1 
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

set(PUBLIC_HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME})
set(BUILD_TESTS OFF)
set(BUILD_TESTS_PROJECT OFF)

include(GNUInstallDirs)

set(OUTPUT_FOLDER "${CMAKE_SOURCE_DIR}/build")
if(DEFINED ENV{SKYRIM_MODS_FOLDER} AND IS_DIRECTORY "$ENV{SKYRIM_MODS_FOLDER}")
    set(OUTPUT_FOLDER "$ENV{SKYRIM_MODS_FOLDER}/${PROJECT_NAME} ${CMAKE_BUILD_TYPE}")
endif()
#set(OUTPUT_FOLDER "C:/Path/To/Custom/Output")

#
# -~-~-~-~-~-   Automate Git Submodule initialization   -~-~-~-~-~-
#

find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if(GIT_SUBMODULE)
        message(STATUS "Submodule update")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init --recursive failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
        endif()
    endif()
endif()

if(NOT EXISTS "${PROJECT_SOURCE_DIR}/extern/CommonLibSSE-NG/CMakeLists.txt")
    message(
      FATAL_ERROR 
      "The CommonLibSSE-NG submodule was not found in ${CMAKE_SOURCE_DIR}/extern/CommonLibSSE-NG/ 
      This may be the result of renaming or moving folders in your project. It also may be the result 
      of modifying the CMake incorrectly. Please refer to the Repo for defaults."
    )
endif()

#
# -~-~-~-~-~- Include Source & Header files recursively -~-~-~-~-~-
#

file(
  GLOB_RECURSE
  headers
  ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
)

list(REMOVE_ITEM headers ${CMAKE_CURRENT_SOURCE_DIR}/include/PCH.h)

file(
  GLOB_RECURSE
  sources
  ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
)

message("Project:\n \tBuild Test: ${BUILD_TESTS_PROJECT}")
if(BUILD_TESTS_PROJECT)
    file(
        GLOB_RECURSE
        tests
        ${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp
    )
endif()

source_group(
  TREE ${CMAKE_CURRENT_SOURCE_DIR}
  FILES ${headers} ${sources}
)

#
# -~-~-~-~-~-   Install CommonLibSSE-NG from Gitmodule  -~-~-~-~-~-
#   Add additional find_package() calls as needed by vcpkg imports
# Add additional add_subdirectory() calls as needed by git submodules

add_subdirectory(extern/CommonLibSSE-NG)
include(extern/CommonLibSSE-NG/cmake/CommonLibSSE.cmake)

add_commonlibsse_plugin(
  ${PROJECT_NAME}
  SOURCES 
    ${headers} 
    ${sources}
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h)

add_library(
  ${PROJECT_NAME}::${PROJECT_NAME} 
  ALIAS 
    ${PROJECT_NAME}
)

# Additional Packages
find_package(spdlog REQUIRED)

#
# -~-~-~-~-~-       Link Libraries & Directories        -~-~-~-~-~-
#         Add additional target_include_directories as needed.

target_include_directories(
  ${PROJECT_NAME}
  PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
    $<INSTALL_INTERFACE:src>
    ${SIMPLEINI_INCLUDE_DIRS}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

#
# -~-~-~-~-~-              Output Control               -~-~-~-~-~-
#

if(BUILD_TESTS_PROJECT)
    message("Project:")
    message("\tStarting Test configure")
    find_package(Catch2 CONFIG REQUIRED)

    include(CTest)
    include(Catch)

    add_executable(
            ${PROJECT_NAME}Tests
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
    message("\tBuild Test Unit Complete")
endif()

if(DEFINED OUTPUT_FOLDER)
    set(DLL_FOLDER "${OUTPUT_FOLDER}/SKSE/Plugins")

    message(STATUS "SKSE plugin output folder: ${DLL_FOLDER}")
    
    if (BUILD_TESTS_PROJECT)
      message(STATUS "Catch2 Test output folder: ${${PROJECT_NAME}_BINARY_DIR}")
    endif()

    if (BUILD_TESTS)
      message(STATUS "CommonLibSSE Test output folder: ${CommonLibSSE_BINARY_DIR}")
    endif()

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

