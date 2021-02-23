#include "headers/directories.h"

#if defined(__ENVIRONMENT_NIX_64) || defined(__ENVIRONMENT_NIX_32) || defined(__ENVIRONMENT_APPLE_64)
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <unistd.h>
#elif defined(__ENVIRONMENT_WIN_64) || defined(__ENVIRONMENT_WIN_32)
#endif

void make_directory(char *name) {
    /* *nix system */
    #if defined(__ENVIRONMENT_NIX_64) || defined(__ENVIRONMENT_NIX_32)
        struct stat st = {0};

        if(stat(name, &st) == -1)
            mkdir(name, 0751);
    #elif defined(__ENVIRONMENT_WIN_32) || defined(__ENVIRONMENT_WIN_64)
        _mkdir(name);
    #elif defined(__ENVIRONMENT_APPLE_64)
        struct stat st = {0};

        if(stat(name, &st) == -1)
            mkdir(name, 0751);
    #endif
}
