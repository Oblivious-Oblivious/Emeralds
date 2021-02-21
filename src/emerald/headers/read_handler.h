#ifndef __READ_HANDLER_H_
#define __READ_HANDLER_H_

#include <stdio.h> /* printf, FILE, fopen */
#include <stdlib.h> /* malloc, NULL */
#include <string.h> /* strlen */

#include "standard_boolean.h"

/**
 * @class M_read_handler
 * @brief File handler for making file read operations more intuitive
 * @param fd -> The current file descriptor
 * @param filepath -> The name of the file to read from
 */
struct read_handler {
    FILE *fd;
    char *filepath;
} read_handler;

/**
 * @func: read_handler_new
 * @brief Create a read handler object
 */
struct read_handler *read_handler_new(void);

/**
 * @message: read_handler_file_does_not_exist
 * @brief Check if the path file exists in the filesystem
 * @return true if it does not exist
 */
static bool read_handler_file_does_not_exist(struct read_handler *self);

/**
 * @message: read_handler_open
 * @brief Open a file in read mode
 * @param filepath -> The path to open
 * @return a boolean signaling if the opening was successful
 */
bool read_handler_open(struct read_handler *self, char *filepath);

/**
 * @message: read_handler_read_line
 * @brief Read a new line from the file descriptor
 * @return The line read
 */
char *read_handler_read_line(struct read_handler *self);

/**
 * @message: read_handler_close
 * @brief Attempts to close the buffers to avoid memory overflows
 */
bool read_handler_close(struct read_handler *self);

#endif
