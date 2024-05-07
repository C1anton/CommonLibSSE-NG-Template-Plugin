# Don't touch this file unless you know what you're doing.

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)

if (${PORT} MATCHES "fully-dynamic-game-engine|skse|qt*")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
else ()
    set(VCPKG_LIBRARY_LINKAGE static)
endif ()
