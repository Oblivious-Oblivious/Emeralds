#include "headers/yaml_processor.h"
#include "headers/read_handler.h"
#include "headers/vector.h"

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

string *get_version_from_yaml(void) {
    char *line;
    string *version;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading version!");

    /* Skip to the version part */
    while((line = read_handler_read_line(h))) {
        version = string_new(line);
        
        string *l = string_substring(version, 0, 7);
        if(!strcmp(string_get(l), "version:")) break;
    }

    return version;
}

string *get_install_script_from_yaml(void) {
    char *line;
    string *script;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading the install script");

    /* Skip to the install part */
    while((line = read_handler_read_line(h))) {
        script = string_new(line);

        string *l = string_substring(script, 0, 7);
        if(!strcmp(string_get(l), "install:")) break;
    }

    vector *install_line = string_split(script, string_new(":"));
    string_skip(vector_get(install_line, 1), 1);
    return vector_get(install_line, 1);
}

string *get_lib_install_script_from_yaml(void) {
    char *line;
    string *script;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading the lib_install script");

    /* Skip to the install part */
    while((line = read_handler_read_line(h))) {
        script = string_new(line);

        string *l = string_substring(script, 0, 11);
        if(!strcmp(string_get(l), "lib_install:")) break;
    }

    vector *install_line = string_split(script, string_new(":"));
    string_skip(vector_get(install_line, 1), 1);
    return vector_get(install_line, 1);
}

string *get_postinstall_script_from_yaml(void) {
    char *line;
    string *script;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading the postinstall script");

    /* Skip to the install part */
    while((line = read_handler_read_line(h))) {
        script = string_new(line);

        string *l = string_substring(script, 0, 11);
        if(!strcmp(string_get(l), "postinstall:")) break;
    }

    vector *install_line = string_split(script, string_new(":"));
    string_skip(vector_get(install_line, 1), 1);
    return vector_get(install_line, 1);
}

string *get_test_script_from_yaml(void) {
    char *line;
    string *script;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading the test script");

    /* Skip to the install part */
    while((line = read_handler_read_line(h))) {
        script = string_new(line);

        string *l = string_substring(script, 0, 4);
        if(!strcmp(string_get(l), "test:")) break;
    }

    vector *test_line = string_split(script, string_new(":"));
    string_skip(vector_get(test_line, 1), 1);
    return vector_get(test_line, 1);
}

string *get_clean_script_from_yaml(void) {
    char *line;
    string *script;

    struct read_handler *h = read_handler_new();
    if(!read_handler_open(h, "em.yml")) return string_new("Error on reading the clean script");

    /* Skip to the clean part */
    while((line = read_handler_read_line(h))) {
        script = string_new(line);

        string *l = string_substring(script, 0, 5);
        if(!strcmp(string_get(l), "clean:")) break;
    }

    vector *clean_line = string_split(script, string_new(":"));
    string_skip(vector_get(clean_line, 1), 1);
    return vector_get(clean_line, 1);
}

