#include "emerald.h"

void print_strings(void *item) {
    printf("%s\n", (char*)item);
}

void usage(void) {
    printf("%s\n", "Usage.");
    exit(1);
}

int main(int argc, char **argv) {
    if(argc < 2) usage();

    char *action = argv[1];
    if(!strcmp(action, "init")) {
        if(argc < 3) usage();

        /* Get the third argument */
        char *name = argv[2];
        initialize_em_library(name);
    }
    else if(!strcmp(action, "list"))
        vector_map(get_dependencies(), (vector_lambda)print_strings);
    else if(!strcmp(action, "install"))
        install_dependencies();
    else if(!strcmp(action, "build")) {
        if(argc < 3) usage();
        
        char *type = argv[2];
        if(!strcmp(type, "app"))
            compile_as_executable();
        else if(!strcmp(type, "lib"))
            compile_as_library();
        else
            usage();
    }
    else if(!strcmp(action, "version"))
        printf("%s\n", get_em_version());
    else
        usage();

    return 0;
}
