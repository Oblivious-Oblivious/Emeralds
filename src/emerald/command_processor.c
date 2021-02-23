#include "headers/command_processor.h"

static void list_deps(string *dep) {
    /* Skip empty lines */
    if(!strcmp(string_get(dep), "")) return;

    /* Remove the first 2 spaces */
    string_skip(dep, 2);
    printf("%s\n", string_get(dep));
}

static void install_deps(string *dep) {
    /* Skip empty lines */
    if(!strcmp(string_get(dep), "")) return;

    /* Remove the first 2 spaces */
    string_skip(dep, 2);
    printf("Installing `%s` ...\n", string_get(dep));
}

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

size_t get_dependencies(void) {
    printf("Listing dependencies...\n");

    vector *deps = get_dependencies_from_yaml();
    vector_map(deps, (vector_lambda)list_deps);

    return vector_length(deps);
}

bool install_dependencies(void) {
    printf("Installing dependencies...\n");

    make_directory("libs");

    vector *deps = get_dependencies_from_yaml();
    if(vector_length(deps) == 0)
        return false;
    else
        vector_map(deps, (vector_lambda)install_deps);
    
    return true;
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
