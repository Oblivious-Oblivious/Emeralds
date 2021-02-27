#ifndef __STRING_H_
#define __STRING_H_

#include <stdio.h> /* snprintf */
#include <stdlib.h> /* malloc, calloc, realloc, free */

#include "standard_string.h" /* strlen, strcmp, memmove */
#include "standard_boolean.h"

#include "vector.h"

/** The initial minimum size of a string **/
static const size_t string_init_capacity = 32;

/**
 * @func: string_lambda
 * @desc: A generic function type used upon iterable data structures
 * @param -> An element belonging to an iterable
 * @return -> A value that satisfies the callee's purpose (map, filter, reduce)
 **/
/* The param void* can have more than 1 argument stored as a list of some sort */
/* Since this is completely generic we can't check for validity of arguments */
/* The validity of the function is dependent on the callee */
typedef char (*string_lambda)();

/**
 * @struct: string
 * @desc: A mutable string of characters used to dynamically build a string.
 * @param str -> The str char* we construct our string into
 * @param alloced -> The total sized allocated for the string
 * @param length -> The total length of the string
 **/
typedef struct string {
    char *str;
    size_t alloced;
    size_t length;
} string;

/**
 * @func: string_ensure_space
 * @desc: Ensure there is enough space for data being added plus a NULL terminator
 * @param sb -> The string builder to use
 * @param add_len -> he length that needs to be added *not* including a NULL terminator
 **/
static void string_ensure_space(string *sb, size_t add_len);

/**
 * @func: string_new
 * @desc: Create an str builder
 * @param initial_string -> The initial string to set
 * @return The str builder
 **/
string *string_new(char *initial_string);

/**
 * @func: string_add_str
 * @desc: Add a string to the builder
 * @param sb -> The string builder to use
 * @param str -> The string to add
 * @param len -> The length of the string to add.
 *              If 0, strlen will be called internally to determine length
 **/
void string_add_str(string *sb, const char *str);

/**
 * @func: string_add_char
 * @desc: Add a character to the builder
 * @param sb -> The string builder to use
 * @param c -> The character to add 
 **/
void string_add_char(string *sb, char c);

/**
 * @func: string_add_int
 * @desc: Add an integer to the builder
 * @param sb -> The string builder to use
 * @param val -> The integer to add
 **/
void string_add_int(string *sb, int val);

/**
 * @func: string_add_double_precision
 * @desc: Add a double to the builder
 * @param sb -> The string builder to use
 * @param val -> The double to add
 **/
void string_add_double_precision(string *sb, double val);

/**
 * @func: string_get
 * @desc: A pointer to the internal buffer with the builder's stirng data
 * @param sb -> The string builder to use
 * @return A pointer to the internal string data
 **/
char *string_get(string *sb);

/**
 * @func: string_get_char_at_index
 * @desc: Accessor to the string characters by index
 * @param sb -> The string builder to use
 * @param index -> The index of the character we want to receive
 * @return The character we searched for
 **/
char string_get_char_at_index(string *sb, size_t index);

/**
 * @func: string_shorten
 * @desc: Remove data from the end of the builder
 * @param sb -> The string builder to use
 * @param len -> The new length of the string, anything after this length is removed
 **/
void string_shorten(string *sb, size_t len);

/**
 * @func: string_delete
 * @desc: Clear the builder
 * @param sb -> The string builder to use
 **/
void string_delete(string *sb);

/**
 * @func: string_skip
 * @desc: Remove data from the beginning of the builder
 * @param sb -> The string builder to use
 * @param len -> The length to remove
 **/
void string_skip(string *sb, size_t len);

/**
 * @func: string_length
 * @desc: The length of the string contained in the builder
 * @param sb -> The string builder to use
 * @return The current length of the string
 **/
size_t string_length(string *sb);

/**
 * @func: string_equals
 * @desc: Checks if the char pointers of the two strings passed are the same
 * @param sb -> The first string
 * @param other -> The second string
 * @return A boolean signaling if the strings are equal
 **/
unsigned char string_equals(string *sb, string *other);

/**
 * @func: string_dup
 * @desc: Return a memory duplicate string
 * @param sb -> The string to duplicate
 * @return The dup string
 **/
string *string_dup(string *sb);

/**
 * @func: string_split
 * @desc: Splits a string to a spesific delimeter
 * @param str -> The string to split
 * @param delimeter -> The string delimeter
 * @return A vector with the string tokens
 **/
vector *string_split(string *str, string *delimeter);

/**
 * @func: string_identifier
 * @desc: Turns a string into a valid identifier by
 *  converting illegal characters to hex codes
 * @param sb -> The string builder to convert
 * @return A valid char pointer identifier
 **/
char *string_identifier(string *sb);

/**
 * @func: string_iterate
 * @desc: Iterates through the characters of the string
 * @param sb -> The string builder we want to iterate
 * @param apply -> The function we apply to each character
 **/
void string_iterate(string *sb, string_lambda apply);

/**
 * @func: string_map
 * @desc: Maps each character of the string according to a modifier function
 * @param sb -> The string builder to map
 * @param modifier -> The string_lambda function to use for the conversions
 * @return A new mapped string
 **/
string *string_map(string *sb, string_lambda modifier);

/**
 * @func: string_filter
 * @desc: Filters out characters from the string according to a function
 * @param sb -> The string builder to filter
 * @param filter -> The labmda function to use
 * @return A new filtered string
 **/
string *string_filter(string *sb, string_lambda filter);

/**
 * @func: string_dup
 * @desc: Return a memory duplicate string
 * @param sb -> The string to duplicate
 * @return The dup string
 **/
string *string_dup(string *sb);

/**
 * @func: string_substring
 * @desc: Return a substring of our current string without modifying the original
 * @param sb -> The string builder we are using
 * @param from -> The point where we start our substring
 * @param to -> The point where we end our substring
 * @return A substring of a copy of the original string
 **/
string *string_substring(string *sb, size_t from, size_t __to);

/**
 * @func: string_free
 * @brief Deallocates the memory of the string
 * @param sb -> The string to free
 */
void string_free(string *sb);

#endif
