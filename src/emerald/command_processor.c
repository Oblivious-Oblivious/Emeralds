#include "headers/command_processor.h"
#include "headers/string.h"
#include "headers/write_handler.h"

static void list_deps(string *dep) {
    /* Skip empty lines */
    if(!strcmp(string_get(dep), "")) return;

    /* Remove the first 2 spaces */
    string_skip(dep, 2);
    vector *depname = string_split(dep, string_new("/"));
    printf("  * %s\n", string_get(vector_get(depname, vector_length(depname) - 1)));

    string_free(dep);
    vector_free(depname);
}

static void install_deps(string *dep) {
    /* Skip empty lines */
    if(!strcmp(string_get(dep), "")) return;

    /* Remove the first 2 spaces */
    string_skip(dep, 2);

    /* Craft the github link */
    string *library = string_new("https://github.com/");
    vector *parts = string_split(dep, string_new(":"));
    string *libpath = vector_get(parts, 0);
    string *liblink = vector_get(parts, 1);
    string_skip(liblink, 1); /* Remove trailing space */
    string_add_str(library, string_get(liblink));

    /* Compile the deps */
    string *command = string_new("git clone ");
    string_add_str(command, "https://github.com/");
    string_add_str(command, string_get(liblink));
    string_add_str(command, " libs/");
    string_add_str(command, string_get(libpath));

    /* Execute git clone */
    printf("%sFetching%s %s\n", "\033[38;5;207m", "\033[0m", string_get(library));
    system(string_get(command));

    /* TODO -> FIX ADD STR SEEMS TO FAIL AT SMALL NAMES */

    string_free(dep);
    string_free(library);
    vector_free(parts);
    string_free(liblink);
    string_free(libpath);
    string_free(command);
}

char *initialize_em_library(char *name) {
    printf("Initializing a new emerald with name `%s`\n", name);
    struct write_handler *h = write_handler_new();

    /* Create the lib directory */
    make_directory(name);

    /* Write the em.yml file */
    string *emfile = string_new(name);
    string_add_str(emfile, "/em.yml");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(emfile));
    write_handler_open(h, string_get(emfile));
    write_handler_write(h, "name: ");
    write_handler_write(h, name);
    write_handler_write(h, "\nversion: 0.1.0\n\ndependencies:\n\nlicense: GPLv3\n\ninstall: make\nlib_install: make lib\npostinstall: #\ntest: make test\n");
    write_handler_close(h);

    /* Initialize a git directory */
    system("git init . >/dev/null 2>&1");
    string *move_git = string_new("mv .git ");
    string_add_str(move_git, name);
    string_add_str(move_git, "/");
    string *git = string_new(name);
    string_add_str(git, "/.git");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(git));
    system(string_get(move_git));

    /* wget a GPLv3 license */
    system("wget https://www.gnu.org/licenses/gpl-3.0.txt >/dev/null 2>&1");
    string *move_license = string_new("mv gpl-3.0.txt ");
    string_add_str(move_license, name);
    string_add_str(move_license, "/LICENSE");
    string *license = string_new(name);
    string_add_str(license, "/LICENSE");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(license));
    system(string_get(move_license));

    /* Write the makefile */
    string *makefile = string_new(name);
    string_add_str(makefile, "/Makefile");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(makefile));
    write_handler_open(h, string_get(makefile));
    write_handler_write(h, "NAME = ");
    write_handler_write(h, name);
    write_handler_write(h, "\n\nCC = clang\nOPT = -O2\nVERSION = -std=c11\n\nFLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\nWARNINGS = \nUNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi\nREMOVE_WARNINGS = \nLIBS = \n\nINPUT = src/$(NAME).c src/$(NAME)/*.c\nOUTPUT = $(NAME)\n\nTESTFILES = ../src/$(NAME)/*.c\nTESTINPUT = $(NAME).spec.c\nTESTOUTPUT = spec_results\n\nall: default\n\ndefault:\n\t$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT)\n\t$(RM) -r export && mkdir export\n\tmv $(OUTPUT) export/\n\nlib: default\n\ntest:\n\tcd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)\n\t@echo\n\t./spec/$(TESTOUTPUT)\n\nspec: test\n\nclean:\n\t$(RM) -r spec/$(TESTOUTPUT)\n\t$(RM) -r export\n\n");
    write_handler_close(h);

    /* Write the .gitignore file */
    string *gitignore = string_new(name);
    string_add_str(gitignore, "/.gitignore");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(gitignore));
    write_handler_open(h, string_get(gitignore));
    write_handler_write(h, "#Prerequisites\n*.d\n\n# Object files\n*.o\n*.ko\n*.obj\n*.elf\n\n# Linker output\n*.ilk\n*.map\n*.exp\n\n# Precompiled Headers\n*.gch\n*.pch\n\n# Executables\n*.exe\n*.out\n*.app\n*.i*86\n*.x86_64\n*.hex\n\n# Debug files\n*.dSYM/\n*.su\n*.idb\n*.pdb\n\n# Kernel Module Compile Results\n# *.mod*\n*.cmd\n.tmp_versions/\nmodules.order\nModule.symvers\nMkfile.old\ndkms.conf\n");
    write_handler_close(h);

    /* Generate a README.md */
    string *readme = string_new(name);
    string_add_str(readme, "/README.md");
    write_handler_open(h, string_get(readme));
    write_handler_write(h, "# ");
    write_handler_write(h, name);
    write_handler_write(h, "\n\nTODO: Write a description here\n\n# Installation\n\nTODO: Write installation instructions here\n\n## Usage\n\nTODO: Write usage instructions here\n\n## Development\n\nTODO: Write development instructions here\n\n## Contributing\n\n1. Fork it (<https://github.com/your-github-user/");
    write_handler_write(h, name);
    write_handler_write(h, "/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [YourName](https://github.com/your-github-user) - creator and maintainer\n");
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
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(src_dir_c));
    write_handler_open(h, string_get(src_dir_c));
    write_handler_write(h, "#include \"");
    write_handler_write(h, name);
    write_handler_write(h, ".h\"\n\nint main(void) {\n    printf(\"%s\\n\", get_value());\n    return 0;\n}\n");
    write_handler_close(h);
    string *src_dir_h = string_new(name);
    string_add_str(src_dir_h, "/src/");
    string_add_str(src_dir_h, name);
    string_add_str(src_dir_h, ".h");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(src_dir_h));
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
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(app_c));
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
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(app_h));
    write_handler_open(h, string_get(app_h));
    write_handler_write(h, "#ifndef __GET_VALUE_H_\n#define __GET_VALUE_H_\n\n/**\n * @func: get_value\n * @brief Returns a greeting as a char*\n * @return char* -> \"Hello, World!\"\n */\nchar *get_value(void);\n\n#endif\n");
    write_handler_close(h);

    /* Create spec files */
    string *spec_str = string_new(name);
    string_add_str(spec_str, "/spec/");
    make_directory(string_get(spec_str));
    string *spec_c = string_new(name);
    string_add_str(spec_c, "/spec/");
    string_add_str(spec_c, name);
    string_add_str(spec_c, ".spec.c");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(spec_c));
    write_handler_open(h, string_get(spec_c));
    write_handler_write(h, "#include \"");
    write_handler_write(h, name);
    write_handler_write(h, ".spec.h\"\n\n");
    write_handler_write(h, "int main(void) {\n    char *v = get_value();\n    int res = strcmp(v, \"Hello, World!\");\n\n    if(res == 0) printf(\"Test (1) passed\\n\");\n\n    return 0;\n}\n");
    write_handler_close(h);
    string *spec_h = string_new(name);
    string_add_str(spec_h, "/spec/");
    string_add_str(spec_h, name);
    string_add_str(spec_h, ".spec.h");
    printf("    %screate%s  %s\n", "\033[38;5;207m", "\033[0m", string_get(spec_h));
    write_handler_open(h, string_get(spec_h));
    write_handler_write(h, "#ifndef __");
    write_handler_write(h, name);
    write_handler_write(h, "_SPEC_H_\n#define __");
    write_handler_write(h, name);
    write_handler_write(h, "_SPEC_H_\n\n#include \"../src/");
    write_handler_write(h, name);
    write_handler_write(h, ".h\"\n\n#include <string.h>\n\n#endif\n");
    write_handler_close(h);

    string_free(emfile);
    string_free(move_git);
    string_free(git);
    string_free(move_license);
    string_free(license);
    string_free(makefile);
    string_free(gitignore);
    string_free(readme);
    string_free(src_dir);
    string_free(src_dir_name);
    string_free(src_dir_c);
    string_free(src_dir_h);
    string_free(app_c);
    string_free(app_h);
    string_free(spec_str);
    string_free(spec_c);
    string_free(spec_h);

    /* Successful creation */
    return name;
}

size_t get_dependencies(void) {
    printf("Emeralds used:\n");

    vector *deps = get_dependencies_from_yaml();
    vector_map(deps, (vector_lambda)list_deps);

    size_t ret = vector_length(deps);

    vector_free(deps);

    return ret;
}

bool install_dependencies(void) {
    printf("%sResolving%s dependencies...\n", "\033[38;5;207m", "\033[0m");

    /* TODO -> CARE FOR CROSS PLATFORM COMPILATION */
    system("rm -rf libs");
    /***********************************************/

    make_directory("libs");

    vector *deps = get_dependencies_from_yaml();
    if(vector_length(deps) == 0)
        return false;
    else
        vector_map(deps, (vector_lambda)install_deps);

    vector_free(deps);
    
    return true;
}

bool run_test_script(void) {
    printf("%sRunning%s tests...\n", "\033[38;5;207m", "\033[0m");
    system(string_get(get_test_script_from_yaml()));
    return true;
}

bool compile_as_executable(void) {
    printf("%sCompiling%s as an executable...\n", "\033[38;5;207m", "\033[0m");
    system(string_get(get_install_script_from_yaml()));
    return true;
}

bool compile_as_library(void) {
    printf("%sCompiling%s as a library...\n", "\033[38;5;207m", "\033[0m");
    system(string_get(get_lib_install_script_from_yaml()));
    return true;
}

char *get_em_version(void) {
    return string_get(get_version_from_yaml());
}
