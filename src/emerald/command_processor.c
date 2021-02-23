#include "headers/command_processor.h"

char *initialize_em_library(char *name) {
    printf("Initializing a new emerald with name `%s`\n", name);

    make_directory(name);
    struct write_handler *h = write_handler_new();

    /* Overrides any previous instance with the same name */
    string *str = string_new(name);
    string_add_str(str, "/em.yml");
    char *filepath = string_get(str);
    if(!write_handler_open(h, filepath)) return "Error on openning file";
    
    if(!write_handler_write(h, "name: ")) return "Error on writing data to file";
    if(!write_handler_write(h, name)) return "Error on writing the name of the library";
    if(!write_handler_write(h, "\nversion: 0.1.0\n\ndependencies:\n\nlicense: GPLv3\n")) return "Error on writing data to file";
    if(!write_handler_close(h)) return "Error on closing the file";

    /* TODO -> GENERATE A GIT FILE AS WELL */
    str = string_new(name);
    string_add_str(str, "/.gitignore");
    char *git_filepath = string_get(str);
    if(!write_handler_open(h, git_filepath)) return "Error on openning file";
    if(!write_handler_close(h)) return "Error on openning file";

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
