#ifndef __COMMAND_PROCESSOR_H_
#define __COMMAND_PROCESSOR_H_

#include "write_handler.h"
#include "yaml_processor.h"
#include "directories.h"

#include "vector.h"
#include "string.h"

/**
 * @func: initialize_em_library
 * @brief Initialize a new emfile with the name specified
 * @param name The name of the new library
 * @return char* -> The name, if the library was created successfully
 */
char *initialize_em_library(char *name);

/**
 * @func: get_dependencies
 * @brief Get the list of dependencies from the yaml file in a vector
 * @return size_t -> The length of the dependencies vector
 */
size_t get_dependencies(void);

/**
 * @func: install_dependencies
 * @brief Installs all missing dependencies for the em library
 * @return bool -> A flag signaling if the install was successful
 */
bool install_dependencies(void);

/**
 * @func: compile_as_executable
 * @brief Compile libraries into shared libraries and source code as a binary executable
 * @return bool -> A flag signaling if the compilation was sucessful
 */
bool compile_as_executable(void);

/**
 * @func: compile_as_library
 * @brief Compile both libraries and source files into shared libraries
 * @return bool -> A flag signaling if the compilation was sucessful
 */
bool compile_as_library(void);

/**
 * @func: run_test_script
 * @brief Runs the test script defined in the em.yml file
 * @return bool -> A flag signaling if the tests ran successful
 */
bool run_test_script(void);

/**
 * @func: run_clean_script
 * @brief Runs the clean script defined in the em.yml file
 * @return bool -> A flag signaling if the clean script was executed
*/
bool run_clean_script(void);

/**
 * @func: get_em_version
 * @brief Get the em version from the yaml file
 * @return char* -> The version
 */
char *get_em_version(void);

#endif
