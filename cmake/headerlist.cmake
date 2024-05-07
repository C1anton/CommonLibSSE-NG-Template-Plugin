# Provide CMAKE with a list of .h header files, source files are handled in "cmake/sourcelist.cmake"

set(headers ${headers}
        src/PCH.h
    src/hook.h
    src/log.h
    src/settings.h
    src/util.h
)