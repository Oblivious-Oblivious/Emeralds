#ifndef __OS_DEFINITIONS_H_
#define __OS_DEFINITIONS_H_

/* Find C version for declaring cross version implementations */
#if defined(__STDC__)
    #if defined(__STDC_VERSION__)
        #if(__STDC_VERSION__ >= 201112L)
            #define __VERSION "C11"
        #elif(__STDC_VERSION__ >= 199901L)
            #define __VERSION "C99"
        #else
            #define __VERSION "C90"
        #endif
    #else
        #define __VERSION "C89"
    #endif
#elif defined(_MSC_VER)
    /* Assume we are running MSVC, that defaults to c90 */
    #define __VERSION "C90"
#endif

/* Windows */
#if _WIN64
    #define __ENVIRONMENT_WIN_64
    #define __MAX_UINT (18446744073709551615UL)
#elif _WIN32
    #define __ENVIRONMENT_WIN_32
    #define __MAX_UINT (4294967295U)

/* GCC */
#elif __x86_64__ || __ppc64__
    #define __ENVIRONMENT_NIX_64
    #define __MAX_UINT (18446744073709551615UL)
#elif __i386__
    #define __ENVIRONMENT_NIX_32
    #define __MAX_UINT (4294967295U)

/* Mac OS */
#elif __APPLE__
    #define __ENVIRONMENT_APPLE_64
    #define __MAX_UINT (18446744073709551615UL)
#endif

#endif
