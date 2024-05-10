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

* [Monitor144hz](https://github.com/Monitor144hz)
* [Skyrim Scripting](https://github.com/SkyrimScripting)
* [Colorglass Studio](https://gitlab.com/colorglass)
* Everyone who uploads [open-source SKSE projects](https://github.com/search?q=commonlibsse-ng&type=repositories) on Github

I plan on maintaining this repository as I continue plugin development, adding and removing features as I deem necessary. Feel free to join the Modding Guild community where you can find and message me directly.

![My Discord](https://discord-readme-badge.vercel.app/api?id=1226917994635202590)

[![](https://dcbadge.limes.pink/api/server/JeJTqCFJ?style=flat-square)](https://discord.gg/JeJTqCFJ)

# Requirements
1. [Visual Studio Community 2022](https://visualstudio.microsoft.com/) or [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/?q=build+tools)
2. [Ninja](https://github.com/ninja-build/ninja/releases) (if using Visual Studio Build Tools)
3. [Vcpkg](https://github.com/microsoft/vcpkg)
4. Setup `VCPKG_ROOT` Environment Variable to `"C:/path/to/vcpkg"`
5. Run `C:/path/to/vcpkg/bootstrap-vcpkg.bat`

# Quickstart
Want a full guide? Checkout my [Full Installation Guide](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/wiki/Installation-Guide) here.

Using [Visual Studio Code](https://visualstudio.microsoft.com/) open the project folder with VSCode.
> Upon opening the project, Visual Studio Code should prompt you to install C++ and/or C++ Cmake Tools. Click yes to all of these options. This will install the necessary extensions Visual Studio Code needs to register and operate a CMake project.

This project was designed and tested within Visual Studio Code. I can't guarantee its effectiveness in other editors.

Once the project finishes loading, it should automatically run a CMake:Configure. If not, select one of the CMake configure presets included in this repo and run a configure.

* Debug (MSVC) - Standard CXX debug compile parameters without Catch2 unit tests.
* Debug with Catch2 (MSVC) - Same as above, but with additional Catch2 unit test libraries.
* Release (MSVC) - Release version for distribution.

Once the CMake:Configure is complete, all of your build files will be located in `/build`. Including CommonLibSSE-NG.

# Project Settings
By default, the build settings will output the .dll into `/build/SKSE/Plugins/` unless you do one of the following:
* Setup an environment variable named `SKYRIM_MODS_FOLDER` pointing to your `Mod Organizer 2/mods/` directory where all your other mods are unpacked and installed. Doing this will output the plugin into `Mod Organizer 2/mods/TemplatePlugin/SKSE/Plugins` going forward.

* Open `CMakeLists.txt` and under "Advanced CMake Configuration & Libraries" locate the `set(OUTPUT_FOLDER ...` options. Here you can modify the output format of `SKYRIM_MODS_FOLDER`, set your own `C:/path/to/folder`, or continue using `"${CMAKE_SOURCE_DIR}/build"`

While you're inside the `CMakeLists.txt` file, you can change your plugin name at the top of the file.
```
project(
    TemplatePlugin <- Specifiy your PluginName
    VERSION 0.0.1 <- Specify your .dll version
    LANGUAGES CXX <- Do not touch
)
```

# Be sure to checkout the [Wiki](https://github.com/Patchu1i/CommonLibSSE-NG-Template-Plugin/wiki) for this Plugin!

# Common CommonLibSSE-NG Plugin Templates
This project wouldn't be possible without these public resources. Will add to the list as I find them.
| Author | Link |
| ---- | ---- |
| Monitor144hz | https://github.com/Monitor144hz/CommonLibSSE-NG-Template-Plugin |
| Colorglass (empty) | https://gitlab.com/colorglass/commonlibsse-ng-plugin-template |
| Colorglass (sample) | https://gitlab.com/colorglass/commonlibsse-sample-plugin |
| Skyrim Scripting | https://github.com/SkyrimScripting/SKSE_Templates |

# SKSE Development Resources

### [Modding-Silo](https://modding-silo.com/)
A work-in-progress website dedicated to documenting modding, and authors.

### [Address Library Database](https://github.com/meh321/AddressLibraryDatabase)
Very useful for SKSE plugin development. Might as well be a required resource at this point.

### [meh321's Address Library Database](https://github.com/meh321/AddressLibraryDatabase)

### [meh321's Address Library Manager](https://github.com/meh321/AddressLibraryManager)

### [https://github.com/atom0s/Steamless/](https://github.com/atom0s/Steamless/)

#### More to come...
