#ifndef __VECTOR_H_
#define __VECTOR_H_

#include <stdlib.h> /* malloc, calloc, realloc, free */

/* Initial capacity of a vector */
static const size_t vector_init_capacity = 32;

/**
 * @func: vector_lambda
 * @desc: A generic function type used upon iterable data structures
 * @param -> An element belonging to an iterable
 * @return -> A value that satisfies the callee's purpose (map, filter, reduce)
 **/
/* The param void* can have more than 1 argument stored as a list of some sort */
/* Since this is completely generic we can't check for validity of arguments */
/* The validity of the function is dependent on the callee */
typedef void* (*vector_lambda)();

/**
 * @struct: vector
 * @desc: Defines a vector data structure
 * @param items -> A void pointer array that contains the heterogenous elements of the vector
 * @param alloced -> The total capacity of the vector
 * @param length -> The total number of values
 **/
typedef struct vector {
    void **items;
    size_t alloced;
    size_t length;
} vector;

/**
 * @func: vector_ensure_space
 * @desc: Ensure there is enough space for our values in the vector
 * @param v -> The vector to use
 * @param capacity -> The new capacity to set
 **/
static void vector_ensure_space(vector *v, size_t capacity);

/**
 * @func: vector_new
 * @desc: Initializes a vector data structure
 * @return: The newly created vector
 **/
vector *vector_new(void);

/**
 * @func: vector_add
 * @desc: Adds a new element in the vector
 * @param v -> The vector to use
 * @param item -> The item to add
 **/
void vector_add(vector *v, void *item);

/**
 * @func: vector_set
 * @desc: Set the value of a specific vector index to a new one
 * @param v-> The vector
 * @param index -> The index to set the value of
 * @param item -> The item to set the value as
 **/
void vector_set(vector *v, size_t index, void *item);

/**
 * @func: vector_get
 * @desc: Get the value of a specific vector index
 * @param v -> The vector to use
 * @param index -> The index to get the value of
 * @return The value
 **/
void *vector_get(vector *v, size_t index);

/**
 * @func: vector_delete
 * @desc: Delete a specific vector value by index
 * @param v -> The vector to use
 * @param index -> The index to delete
 **/
void vector_delete(vector *v, size_t index);

/**
 * @func: vector_length
 * @desc: Get the total number of values inserted in the vector
 * @param v -> The vector to use
 * @return: The number of items in the vector
 **/
size_t vector_length(vector *v);

/**
 * @func: vector_dup
 * @desc: Get a memory duplicate of the passed vector
 * @param v -> The vector to use
 * @return The duplicate vector
 **/
vector *vector_dup(vector *v);

/**
 * @func: vector_map
 * @desc: Maps all vector elements in iteration using a modifier function pointer
 * @param v -> The vector to map
 * @param modifier -> The modifier function
 * @return The mapped vector duplicate
 **/
vector *vector_map(vector *v, vector_lambda modifier);

/**
 * @func: vector_filter
 * @desc: Filters all vector elements in iteration using a filter function
 * @param v -> The vector to filter
 * @param filter -> The filter function
 * @return The filtered vector duplicate
 **/
vector *vector_filter(vector *v, vector_lambda filter);

/**
 * @func: vector_reduce
 * @desc: Recudes all vector elements into a void* result using a foldl function
 * @param v -> The vector to reduce
 * @param fold -> The folding function to use
 * @return The folder void* result
 **/
void *vector_reduce(vector *v, vector_lambda fold);

/**
 * @func: vector_free
 * @brief Deallocated the vector memory
 * @param v -> The vector to free
 */
void vector_free(vector *v);

#endif
