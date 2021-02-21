/*
    Copyright (C) 1991-2020 Free Software Foundation, Inc.
    This file is part of the GNU C Library.
    Written by Torbjorn Granlund (tege@sics.se),
    with help from Dan Sahlin (dan@sics.se);
    commentary by Jim Blandy (jimb@ai.mit.edu).

    The GNU C Library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    The GNU C Library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with the GNU C Library; if not, see
    <http://www.gnu.org/licenses/>.
*/

#ifndef __STANDARD_STRING_H_
#define __STANDARD_STRING_H_

#include <stdlib.h>

#define strlen _strlen
#define memmove _memmove
#define strcmp _strcmp

/**
 * @func: _strlen
 * @desc: Return the length of the null-terminated string STR. Scan for
    the null terminator quickly by testing four bytes at a time
 * @param str -> The char* to check
 * @return The size of the string
 **/
static size_t _strlen(const char *str) {
    unsigned long *aligned_addr;
    unsigned long himagic = 0x80808080;
    unsigned long lomagic = 0x01010101;
    const char *start = str;

    if(!((long)str & (sizeof(long) - 1))) {
        /* If the string is word-aligned, we can check for the presence of
           a null in each word-sized block. */
        aligned_addr = (unsigned long*)str;
        while(!(((*aligned_addr) - lomagic) & ~(*aligned_addr) & himagic))
            aligned_addr++;

        /* Once a null is detected, we check each byte in that block for a
           precise position of the null. */
        str = (char*)aligned_addr;
    }

    while(*str)
        str++;

    return str - start;
}

/**
 * @func: _memmove
 * @desc: Accurate equivalent of string.h 'memmove' function
 * @param destination_out -> The dest pointer to move memory to
 * @param source_in -> The source string to copy from
 * @param n -> The size of the source string
 **/
static void* _memmove(void *destination_out, const void *source_in, size_t n) {
    unsigned char *pd = (unsigned char*)destination_out;
    const unsigned char *ps = (unsigned char*)source_in;

    if(ps < pd)
        for(pd += n, ps += n; n--;)
            *--pd = *--ps;
    else
        while(n--)
            *pd++ = *ps++;

    return destination_out;
}

/**
 * @func: _strcmp
 * @desc: Accurate equivalent of string.h 'strcmp' function
 * @param p1 -> The first string
 * @param p2 -> The second string
 * @return 0, -1, or 1
 **/
static int _strcmp(const char *p1, const char *p2) {
    const unsigned char *s1 = (const unsigned char*)p1;
    const unsigned char *s2 = (const unsigned char*)p2;
    unsigned char c1, c2;

    do {
        c1 = (unsigned char)*s1++;
        c2 = (unsigned char)*s2++;
        if(c1 == '\0')
            return c1 - c2;
    } while(c1 == c2);

    return c1 - c2;
}

#endif
