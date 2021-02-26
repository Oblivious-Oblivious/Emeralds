#include "emerald.h"

void usage(void) {
    printf("emerald/em [<command>]\n\n");
    printf("Commands:\n");
    printf("    build [app | lib] - Build the application in the `export` directory.\n");
    printf("    init [name]       - Initialize a new library with an em.yml file.\n");
    printf("    install           - Install dependencies recursively for each included library.\n");
    printf("    list              - List dependencies in the em file.\n");
    printf("    version           - Print the current version of the emerald.\n");
    printf("    help              - Print this help message.\n");
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
        get_dependencies();
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
    else if(!strcmp(action, "help"))
        usage();
    else
        usage();

    return 0;
}
