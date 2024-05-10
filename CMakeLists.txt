cmake_minimum_required(VERSION 3.21)

#
# -~-~-~-~-~-              Project Setup                -~-~-~-~-~-
#

project(
    TemplatePlugin 
    VERSION 0.0.1 
    LANGUAGES CXX
)

set(AUTHOR YourName)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

set(PUBLIC_HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME})
set(BUILD_TEST_SUITE OFF)

include(GNUInstallDirs)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.rc.in
  ${CMAKE_CURRENT_BINARY_DIR}/version.rc
  @ONLY
)

set(OUTPUT_FOLDER "${CMAKE_SOURCE_DIR}/build")

if(DEFINED ENV{SKYRIM_MODS_FOLDER} AND IS_DIRECTORY "$ENV{SKYRIM_MODS_FOLDER}")
    set(OUTPUT_FOLDER "$ENV{SKYRIM_MODS_FOLDER}/${PROJECT_NAME} ${CMAKE_BUILD_TYPE}")
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
  ${CMAKE_CURRENT_BINARY_DIR}/version.rc
)

message("[Test Suite]: ${BUILD_TEST_SUITE}")
if(BUILD_TEST_SUITE)
    message("[Test Suite] Including ${PROJECT_NAME}/tests into Build.")
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

# -~-~-~-~-~-   Install CommonLibSSE-NG from Gitmodule  -~-~-~-~-~-

add_subdirectory(extern/CommonLibSSE-NG)
include(extern/CommonLibSSE-NG/cmake/CommonLibSSE.cmake)

add_commonlibsse_plugin(
  ${PROJECT_NAME}
  AUTHOR AuthorName
  SOURCES ${headers} ${sources}
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23) # <--- use C++23 standard
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h) # <--- PCH.h is required!

add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Additional Packages
find_package(spdlog REQUIRED)

#
# -~-~-~-~-~-       Link Libraries & Directories        -~-~-~-~-~-
#

# Use for newly added libraries.
# target_link_libraries(
#   ${PROJECT_NAME}
#   PRIVATE
#       SomeLibrary::SomeLibrary
# )

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

if(BUILD_TEST_SUITE)
    message("[Test Suite] Starting Test configure")
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
    message("[Test Suite] Build Test Unit Complete: ${PROJECT_NAME}/tests/${PROJECT_NAME}Tests")
endif()

if(DEFINED OUTPUT_FOLDER)
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

