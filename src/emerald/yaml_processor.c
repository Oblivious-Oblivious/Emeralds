#include "headers/yaml_processor.h"
#include "headers/read_handler.h"

/* TODO -> ADD AN ACTUAL YAML FILE HANDLER */

vector *get_dependencies_from_yaml(void) {
    char *line;
    vector *deps = vector_new();

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return deps;

    /* Skip to the dependencies part */
    while((line = read_handler_read_line(h)))
        if(!strcmp(line, "dependencies:")) break;

    /* Start reading dependencies */
    while((line = read_handler_read_line(h))) {
        string *l = string_new(line);
        l = string_substring(l, 0, 7);
        if(!strcmp(string_get(l), "license:")) break;
        vector_add(deps, string_new(line));
    }

    return deps;
}
