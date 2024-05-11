# Skyrim SKSE CommonLibSSE-NG Plugin Template
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/issues) [![build](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/actions/workflows/cmake-action.yml/badge.svg)](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/actions/workflows/cmake-action.yml)

A Plugin Template for CommonLibSSE-NG to build for Skyrim versions SE, AE, VR, and GOG. Included libraries:

| Plugin | README |
| ------ | ------ |
| CommonLibSSE-NG | https://github.com/CharmedBaryon/CommonLibSSE-NG/ |
| [SimpleINI](https://github.com/brofield/simpleini) | Read/Write ini configurations. |
| [spdlog](https://github.com/gabime/spdlog) | Used for logging to log file. |
| [RapidCSV](https://github.com/d99kris/rapidcsv) | Used by CommonLibSSE for unit tests  |
| [Catch2](https://github.com/catchorg/Catch2) | A unit testing framework for C++ |

I set out to create this template for two reasons: 
1. Offer another updated solution for would-be SKSE plugin developers to utilize and learn plugin development. 
2. Offer a more packaged template with some common tools such as catch2, simpleini, and spdlog.

This work absolutely could not be done without these authors and their original works and derivatives:

* [Monitor144hz](https://github.com/Monitor144hz) - For their various NG repositories.
* [Skyrim Scripting](https://github.com/SkyrimScripting) - For their Youtube series, and templates.
* [Colorglass Studio](https://gitlab.com/colorglass) - For their sample plugin and vcpkg repository.
* [Parapets](https://github.com/Exit-9B) - For inspiring me to use git submodules instead of vcpkg.
* [CharmedByron](https://github.com/CharmedBaryon) - For the NG fork of CommonLibSSE, and documentation.
* Everyone who uploads [open-source SKSE projects](https://github.com/search?q=commonlibsse-ng&type=repositories) on Github

I plan on maintaining this repository as I continue plugin development, adding and removing features as I deem necessary. Feel free to join the Modding Guild community where you can find and message me directly.

<img src="https://discord-readme-badge.vercel.app/api?id=1226917994635202590" width=25% height=35%>

[![](https://dcbadge.limes.pink/api/server/JeJTqCFJ?style=flat-square)](https://discord.gg/JeJTqCFJ)

# Requirements
1. [Visual Studio Code](https://code.visualstudio.com/) + [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/?q=build+tools) or [Visual Studio Community 2022](https://visualstudio.microsoft.com/)
2. [Git](https://git-scm.com/downloads) or [Github Desktop](https://desktop.github.com/)
3. [Ninja](https://github.com/ninja-build/ninja/releases) (if using Visual Studio Build Tools)
4. [Vcpkg](https://github.com/microsoft/vcpkg)

# Quickstart
Want a full guide? Checkout my [Full Installation Guide](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/wiki/Installation-Guide) here.

1. Setup `VCPKG_ROOT` system envrionment variable to point towards `"C:/path/to/vcpkg"`
2. (optional) Setup `SKYRIM_MODS_FOLDER` system environment variable to point twards `"C:/path/to/Mod Organizer 2/mods/folder`"
   > Not doing this will result in the DLL exporting to `"${CMAKE_SOURCE_DIR}/build"` instead.
3. (optional) If using Visual Studio Code, Add `"C:/path/to/ninja/ninja.exe"` to your envrionment PATH.
4. Using [Visual Studio Code](https://visualstudio.microsoft.com/) open the project folder with VSCode.
5. If prompted, install both C/C++ & CMake tools provided by Visual Studio Code.
6. Select a configure preset
* Debug (MSVC) - Standard CXX debug compile parameters without Catch2 unit tests.
* Debug with Catch2 (MSVC) - Same as above, but with additional Catch2 unit test libraries.
* Release (MSVC) - Release version for distribution.
7. Click `Build` and allow it time to compile.

# Project Settings
By default, the build settings will output the .dll into `"/build/SKSE/Plugins/"` unless you setup your `SKYRIM_MODS_FOLDER` as detailed above.

While you're inside the `CMakeLists.txt` file, you can change your plugin name at the top of the file.
```
project(
    TemplatePlugin <- Specifiy your PluginName
    VERSION 0.0.1 <- Specify your .dll version
    LANGUAGES CXX <- Do not touch
)
```
Just below that, you can configure optional Build settings.
```
set(BUILD_TESTS OFF) <- OFF/ON enables CommonLibSSE-NG specific Catch2 unit tests (default OFF).
set(BUILD_TESTS_PROJECT OFF) <- OFF/ON enables Project specific Catch2 unit tests (default OFF).
```
Further down, you can modify your .dll output directory.
```
set(OUTPUT_FOLDER "${CMAKE_SOURCE_DIR}/build") <- Used if `SKYRIM_MODS_FOLDER` is not set.
if(DEFINED ENV{SKYRIM_MODS_FOLDER} AND IS_DIRECTORY "$ENV{SKYRIM_MODS_FOLDER}")
    set(OUTPUT_FOLDER "$ENV{SKYRIM_MODS_FOLDER}/${PROJECT_NAME} ${CMAKE_BUILD_TYPE}") 
endif()
#set(OUTPUT_FOLDER "C:/Path/To/Custom/Output") <- Uncomment and use for custom path.
```

## Be sure to checkout the [Wiki](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/wiki) for this Plugin!

# SKSE Development Resources

### [Modding-Silo](https://modding-silo.com/)
A work-in-progress website dedicated to documenting modding, and authors.

### [Address Library Database](https://github.com/meh321/AddressLibraryDatabase)
Very useful for SKSE plugin development. Might as well be a required resource at this point.

### [meh321's Address Library Database](https://github.com/meh321/AddressLibraryDatabase)

### [meh321's Address Library Manager](https://github.com/meh321/AddressLibraryManager)

### [https://github.com/atom0s/Steamless/](https://github.com/atom0s/Steamless/)

### [CommonLibSSE-NG Generated Code Documnetation](https://ng.commonlib.dev/)

#### More to come...
