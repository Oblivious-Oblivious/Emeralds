#ifndef __YAML_PROCESSOR_H_
#define __YAML_PROCESSOR_H_

#include "vector.h"

struct yaml_processor {
    char *filename;
};

/**
 * @func: yaml_processor_new
 * @brief Creates a new yaml_processor object
 * @param filename -> A name of the emfile to process
 * @return struct yaml_processor* -> The newly created object
 */
struct yaml_processor *yaml_processor_new(char *filename);

/**
 * @func: get_dependencies_from_yaml
 * @brief Get the dependencies from yaml file
 * @param y -> The yaml_processor containing the name of the file
 * @return vector* -> The list of dependencies
 */
vector *get_dependencies_from_yaml(struct yaml_processor *y);

#endif
