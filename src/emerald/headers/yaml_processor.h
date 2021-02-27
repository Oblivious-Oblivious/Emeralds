#ifndef __YAML_PROCESSOR_H_
#define __YAML_PROCESSOR_H_

#include "vector.h"
#include "string.h"
#include "read_handler.h"

/**
 * @func: get_dependencies_from_yaml
 * @brief Get the dependencies from yaml file
 * @return vector* -> The list of dependencies
 */
vector *get_dependencies_from_yaml(void);

/**
 * @func: get_version_from_yaml
 * @brief Read the version field from the yaml file
 * @return string* -> The version as a string object
 */
string *get_version_from_yaml(void);

/**
 * @func: get_install_script_from_yaml
 * @brief Get the install script from yaml file
 * @return string* -> The install field
 */
string *get_install_script_from_yaml(void);

/**
 * @func: get_lib_install_script_from_yaml
 * @brief Get the lib install script from yaml file
 * @return string* -> The lib_install field
 */
string *get_lib_install_script_from_yaml(void);

/**
 * @func: get_postinstall_script_from_yaml
 * @brief Get the postinstall script from yaml file
 * @return string* -> The postinstall field
 */
string *get_postinstall_script_from_yaml(void);

/**
 * @func: get_test_script_from_yaml
 * @brief Get the test script from yaml file
 * @return string* -> The test field
 */
string *get_test_script_from_yaml(void);

/**
 * @func: get_clean_script_from_yaml
 * @brief Get the clean sript from the yaml file
 * @return string* -> The clean field
 */
string *get_clean_script_from_yaml(void);

#endif
