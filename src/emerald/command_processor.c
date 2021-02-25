#include "headers/command_processor.h"
#include "headers/string.h"
#include "headers/write_handler.h"

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

    /* Craft the github link */
    string *library = string_new("https://github.com/");
    vector *parts = string_split(dep, string_new(":"));
    string *liblink = vector_get(parts, 1);
    string_skip(liblink, 1); /* Remove trailing space */
    string_add_str(library, string_get(liblink));

    /* Create the directory to clone the dependencies at */
    string *dep_path = string_new("libs/");
    string_add_str(dep_path, string_get(vector_get(parts, 0)));
    /* TODO -> DELETE DIRECTORY FIRST BEFORE OVERWRITTING LIBS */
    make_directory(string_get(dep_path));

    /* Compile the deps */
    string *command = string_new("git clone ");
    string_add_str(command, string_get(library));

    /* Execute git clone */
    system(string_get(command));

    /* Move to the libs library */
    string *move_command = string_new("mv ");
    string_add_str(move_command, string_get(vector_get(parts, 0)));
    /* TODO -> FIX ADD STR SEEMS TO FAIL AT SMALL NAMES */
    string_add_str(move_command, " libs/");
    system(string_get(move_command));
}

char *initialize_em_library(char *name) {
    printf("Initializing a new emerald with name `%s`\n", name);
    struct write_handler *h = write_handler_new();

    /* Create the lib directory */
    make_directory(name);

    /* Write the em.yml file */
    string *str = string_new(name);
    string_add_str(str, "/em.yml");
    write_handler_open(h, string_get(str));
    write_handler_write(h, "name: ");
    write_handler_write(h, name);
    write_handler_write(h, "\nversion: 0.1.0\n\ndependencies:\n\nlicense: GPLv3\n\ninstall: make\n\npostinstall: #\n");
    write_handler_close(h);

    /* Write the makefile */
    str = string_new(name);
    string_add_str(str, "/Makefile");
    write_handler_open(h, string_get(str));
    write_handler_write(h, "NAME = ");
    write_handler_write(h, name);
    write_handler_write(h, "\n\nCC = clang\nOPT = -O2\nVERSION = -std=c11\n\nFLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\nWARNINGS = \nUNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi\nREMOVE_WARNINGS = \nLIBS = \n\nINPUT = src/$(NAME).c src/$(NAME)/*.c\nOUTPUT = $(NAME)\n\nTESTFILES = sources/$(NAME)/*.c\nTESTINPUT = $(NAME).spec.c\nTESTOUTPUT = spec_results\n\nall: default\n\ndefault:\n\t$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT)\n\t$(RM) -r export && mkdir export\n\tmv $(OUTPUT) export/\n\ntest:\n\tmkdir spec/sources/ && cp -r src/* spec/sources/\n\tcd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)\n\t@echo\n\t./spec/$(TESTOUTPUT)\n\nspec: test\n\nclean:\n\t$(RM) -r spec/$(TESTOUTPUT)\n\t$(RM) -r spec/sources\n\t$(RM) -r export\n\n");
    write_handler_close(h);

    /* Write the gitignore file */
    str = string_new(name);
    string_add_str(str, "/.gitignore");
    write_handler_open(h, string_get(str));
    /* TODO -> GENERATE .GIT OPTIONS */
    write_handler_close(h);

    /* Create source files */
    string *src_dir = string_new(name);
    string_add_str(src_dir, "/src/");
    make_directory(string_get(src_dir));
    string *src_dir_name = string_new(name);
    string_add_str(src_dir_name, "/src/");
    string_add_str(src_dir_name, name);
    make_directory(string_get(src_dir_name));
    string *src_dir_c = string_new(name);
    string_add_str(src_dir_c, "/src/");
    string_add_str(src_dir_c, name);
    string_add_str(src_dir_c, ".c");
    write_handler_open(h, string_get(src_dir_c));
    write_handler_write(h, "#include \"");
    write_handler_write(h, name);
    write_handler_write(h, ".h\"\n\nint main(void) {\n    printf(\"%s\\n\", get_value());\n    return 0;\n}\n");
    write_handler_close(h);
    string *src_dir_h = string_new(name);
    string_add_str(src_dir_h, "/src/");
    string_add_str(src_dir_h, name);
    string_add_str(src_dir_h, ".h");
    write_handler_open(h, string_get(src_dir_h));
    write_handler_write(h, "#ifndef __");
    write_handler_write(h, name);
    write_handler_write(h, "_H_\n");
    write_handler_write(h, "#define __");
    write_handler_write(h, name);
    write_handler_write(h, "_H_\n\n");
    write_handler_write(h, "#include <stdio.h>\n\n#include \"");
    write_handler_write(h, name);
    write_handler_write(h, "/headers/get_value.h\"\n\n#endif\n");
    write_handler_close(h);
    string *app_c = string_new(name);
    string_add_str(app_c, "/src/");
    string_add_str(app_c, name);
    make_directory(string_get(app_c));
    string_add_str(app_c, "/get_value.c");
    write_handler_open(h, string_get(app_c));
    write_handler_write(h, "#include \"headers/get_value.h\"\n\nchar *get_value(void) {\n    return \"Hello, World!\";\n}\n");
    write_handler_close(h);
    string *app_h = string_new(name);
    string_add_str(app_h, "/src/");
    string_add_str(app_h, name);
    make_directory(string_get(app_h));
    string_add_str(app_h, "/headers");
    make_directory(string_get(app_h));
    string_add_str(app_h, "/get_value.h");
    write_handler_open(h, string_get(app_h));
    write_handler_write(h, "#ifndef __GET_VALUE_H_\n#define __GET_VALUE_H_\n\n/**\n * @func: get_value\n * @brief Returns a greeting as a char*\n * @return char* -> \"Hello, World!\"\n */\nchar *get_value(void);\n\n#endif\n");
    write_handler_close(h);

    /* Create spec files */
    string *spec_str = string_new(name);
    string_add_str(spec_str, "/spec/");
    make_directory(string_get(spec_str));
    string *spec_c = string_dup(spec_str);
    string_add_str(spec_c, name);
    string_add_str(spec_c, ".spec.c");
    write_handler_open(h, string_get(spec_c));
    write_handler_write(h, "#include \"");
    write_handler_write(h, name);
    write_handler_write(h, ".spec.h\"\n\n");
    write_handler_write(h, "int main(void) {\n    char *v = get_value();\n    int res = strcmp(v, \"Hello, World!\");\n\n    if(res == 0) printf(\"Test (1) passed\\n\");\n\n    return 0;\n}\n");
    write_handler_close(h);
    string *spec_h = string_dup(spec_str);
    string_add_str(spec_h, name);
    string_add_str(spec_h, ".spec.h");
    write_handler_open(h, string_get(spec_h));
    write_handler_write(h, "#ifndef __");
    write_handler_write(h, name);
    write_handler_write(h, "_SPEC_H_\n#define __");
    write_handler_write(h, name);
    write_handler_write(h, "_SPEC_H_\n\n#include \"sources/");
    write_handler_write(h, name);
    write_handler_write(h, ".h\"\n\n#include <string.h>\n\n#endif\n");
    write_handler_close(h);

    /* TODO -> STRING BUILDER FAILS TO ADD ON UNKOWN CONDITIONS AS OF NOW */

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

/* TODO -> COMPLETE THE COMPILATION COMMANDS */
bool compile_as_executable(void) {
    printf("Compiling as an executable...\n");
    return false;
}

bool compile_as_library(void) {
    printf("Compiling as a library...\n");
    return false;
}

char *get_em_version(void) {
    return string_get(get_version_from_yaml());
}
