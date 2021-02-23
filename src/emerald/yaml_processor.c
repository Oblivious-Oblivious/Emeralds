#include "headers/yaml_processor.h"

struct yaml_processor *yaml_processor_new(char *filename) {
    struct yaml_processor *y = (struct yaml_processor*)malloc(sizeof(struct yaml_processor));
    y->filename = filename;

    return y;
}

vector *get_dependencies_from_yaml(struct yaml_processor *y) {
    return vector_new();
}
