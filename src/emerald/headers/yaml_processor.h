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

#endif
