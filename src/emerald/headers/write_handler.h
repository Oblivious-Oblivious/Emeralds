#ifndef __WRITE_HANDLER_H_
#define __WRITE_HANDLER_H_

#include <stdio.h> /* printf, FILE, fopen */
#include <stdlib.h> /* malloc, NULL */

#include "standard_boolean.h"

/**
 * @struct write_handler
 * @brief File handler for making write operations more intuitive
 * @param fd -> The current file descriptor
 * @param filepath -> The name of the file to write to
 */
struct write_handler {
    FILE *fd;
    char *filepath;
} write_handler;

/**
 * @func: write_handler_new
 * @brief Create a read handler object
 */
struct write_handler *write_handler_new(void);

/**
 * @func: write_handler_delete_previous_file
 * @brief Delete any previous instance of the file
 * @param self -> The write handler to use and mutate
 */
static void write_handler_delete_previous_file(struct write_handler *self);

/**
 * @func: write_handler_open
 * @brief Open a file in write mode
 * @param self -> The write handler to use and mutate
 * @param filepath -> The path to open
 * @return a boolean signaling if the opening was successful
 */
bool write_handler_open(struct write_handler *self, char *filepath);

/**
 * @func: write_handler_write
 * @brief Write a string in the file
 * @param self -> The write handler to use and mutate
 * @param str -> The string to write
 * @return a boolean signaling if the opening was successful
 */
bool write_handler_write(struct write_handler *self, char *str);

/**
 * @func: write_handler_write_line
 * @brief Writes a line in the file
 * @param self -> The write handler to use and mutate
 * @param line -> The line to write
 * @return a boolean signaling if the opening was successful
 */
bool write_handler_write_line(struct write_handler *self, char *line);

/**
 * @func: write_handler_close
 * @brief Attempts to close the buffers to avoid memory overflows
 * @param self -> The write handler to use and mutate
 * @return a boolean signaling if the opening was successful
 */
bool write_handler_close(struct write_handler *self);

#endif
