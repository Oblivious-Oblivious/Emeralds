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

#endif
