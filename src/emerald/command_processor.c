#include "headers/command_processor.h"
#include "headers/string.h"

char *initialize_em_library(char *name) {
    printf("Initializing a new emerald with name `%s`\n", name);

    struct write_handler *h = write_handler_new();

    /* Overrides any previous instance with the same name */
    if(!write_handler_open(h, name)) return "Error on openning file";
    
    if(!write_handler_write(h, "name: ")) return "Error on writing data to file";
    if(!write_handler_write(h, name)) return "Error on writing the name of the library";
    if(!write_handler_write(h, "\nversion: 0.1.0\n\ndependencies:\n\nlicense: GPLv3\n")) return "Error on writing data to file";

    /* TODO -> GENERATE A GIT FILE AS WELL */

    /* Successful creation */
    return name;
}

vector *get_dependencies(void) {
    printf("Listing dependencies...\n");

    /* TODO -> OPTIMIZE REPETITION */
    struct yaml_processor *y = yaml_processor_new("test");
    return get_dependencies_from_yaml(y);
}

bool install_dependencies(void) {
    printf("Installing dependencies...\n");
    return false;
}

bool compile_as_executable(void) {
    printf("Compiling as an executable...\n");
    return false;
}

bool compile_as_library(void) {
    printf("Compiling as a library...\n");
    return false;
}

char *get_em_version(void) {
    return string_get(string_new("cEmeralds: 0.1.0"));
}
