require "file_utils"
require "colorize"

require "./yaml_processor"

##
# @class CommandProcessor
# @brief Bundles up the code for all commands
##
class Emerald::CommandProcessor
    getter yaml;

    private def list_dep(dep : String)
        if dep != ""
            parts = dep
                .split(" => ")
                .map(&.lstrip "\"")
                .map(&.rstrip "\"");
            puts "  * #{parts[0]}";
        end
    end

    private def install_dep(dep : String)
        if dep != ""
            parts = dep
                .split(" => ")
                .map(&.lstrip "\"")
                .map(&.rstrip "\"");
            `git clone https://github.com/#{parts[1]} libs/#{parts[0]}`;
        end
    end

    def initialize
        @yaml = YamlProcessor.new;
    end

    ##
    # @message usage
    # @brief Outputs example usage for emeralds
    ##
    def usage
        puts "emeralds/em [<command>]\n\n";
        puts "Commands:\n";
        puts "    build [app | lib] - Build the application in the `export` directory.\n";
        puts "    clean             - Run the clean script\n";
        puts "    help              - Print this help message.\n";
        puts "    init [name]       - Initialize a new library with an em.yml file.\n";
        puts "    install           - Install dependencies recursively for each included library.\n";
        puts "    list              - List dependencies in the em file.\n";
        puts "    test              - Run the script of tests.\n";
        puts "    version           - Print the current version of the emerald.\n";
        exit 1;
    end

    ##
    # @message: initialize_em_library
    # @brief Initialize a new emfile with the name specified
    # @param name The name of the new library
    # @return -> The name, if the library was created successfully
    ##
    def initialize_em_library(name : String) : String
        puts "Initializing a new emerald with name `#{name}`";

        # Create the lib directory
        Dir.mkdir name, mode: 751;

        # Write the em.yml file
        puts "#{"create".colorize(:magenta)} #{name}/em.yml";
        File.write "#{name}/em.yml", "name: #{name}\nversion: 0.1.0\n\ndependencies:\n\nlicense: GPLv3\n\ninstall: make\nlib_install: make lib\npostinstall: #\ntest: make test\nclean: make clean\n";

        # Initialize a git directory
        puts "#{"create".colorize(:magenta)} #{name}/.git";
        `git init #{name}/ >/dev/null 2>&1`;

        # Wget a GPLv3 license
        # TODO -> CARE FOR CROSS COMPILATION
        puts "#{"create".colorize(:magenta)} #{name}/LICENSE";
        `wget -O #{name}/LICENSE https://www.gnu.org/licenses/gpl-3.0.txt >/dev/null 2>&1`;

        # Write the makefile
        puts "#{"create".colorize(:magenta)} #{name}/Makefile";
        File.write "#{name}/Makefile", "NAME = #{name}\n\nCC = clang\nOPT = -O2\nVERSION = -std=c11\n\nFLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\nWARNINGS = \nUNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi\nREMOVE_WARNINGS = \nLIBS = \n\nINPUT = src/$(NAME).c src/$(NAME)/*.c\nOUTPUT = $(NAME)\n\nTESTFILES = ../src/$(NAME)/*.c\nTESTINPUT = $(NAME).spec.c\nTESTOUTPUT = spec_results\n\nall: default\n\ndefault:\n\t$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT)\n\t$(RM) -r export && mkdir export\n\tmv $(OUTPUT) export/\n\nlib: default\n\ntest:\n\tcd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)\n\t@echo\n\t./spec/$(TESTOUTPUT)\n\nspec: test\n\nclean:\n\t$(RM) -r spec/$(TESTOUTPUT)\n\t$(RM) -r export\n\n";

        # Write the .gitignore file
        puts "#{"create".colorize(:magenta)} #{name}/.gitignore";
        File.write "#{name}/.gitignore", "#Prerequisites\n*.d\n\n# Object files\n*.o\n*.ko\n*.obj\n*.elf\n\n# Linker output\n*.ilk\n*.map\n*.exp\n\n# Precompiled Headers\n*.gch\n*.pch\n\n# Executables\n*.exe\n*.out\n*.app\n*.i*86\n*.x86_64\n*.hex\n\n# Debug files\n*.dSYM/\n*.su\n*.idb\n*.pdb\n\n# Kernel Module Compile Results\n# *.mod*\n*.cmd\n.tmp_versions/\nmodules.order\nModule.symvers\nMkfile.old\ndkms.conf\n";

        # Generate a README.md
        puts "#{"create".colorize(:magenta)} #{name}/README.md";
        File.write "#{name}/README.md", "# #{name}\n\nTODO: Write a description here\n\n# Installation\n\nTODO: Write installation instructions here\n\n## Usage\n\nTODO: Write usage instructions here\n\n## Development\n\nTODO: Write development instructions here\n\n## Contributing\n\n1. Fork it (<https://github.com/your-github-user/#{name}/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [YourName](https://github.com/your-github-user) - creator and maintainer\n";

        # Create source directories
        Dir.mkdir "#{name}/src", mode: 751;
        Dir.mkdir "#{name}/src/#{name}", mode: 751;
        Dir.mkdir "#{name}/src/#{name}/headers", mode: 751;

        # Create source files
        puts "#{"create".colorize(:magenta)} #{name}/src/#{name}.c";
        File.write "#{name}/src/#{name}.c", "#include \"#{name}.h\"\n\nint main(void) {\n    printf(\"%s\\n\", get_value());\n    return 0;\n}\n";
        puts "#{"create".colorize(:magenta)} #{name}/src/#{name}.h";
        File.write "#{name}/src/#{name}.h", "#ifndef __#{name.upcase}_H_\n#define __#{name.upcase}_H_\n\n#include <stdio.h>\n\n#include \"#{name}/headers/get_value.h\"\n\n#endif\n";
        puts "#{"create".colorize(:magenta)} #{name}/src/#{name}/get_value.c";
        File.write "#{name}/src/#{name}/get_value.c", "#include \"headers/get_value.h\"\n\nchar *get_value(void) {\n    return \"Hello, World!\";\n}\n";
        puts "#{"create".colorize(:magenta)} #{name}/src/#{name}/headers/get_value.h";
        File.write "#{name}/src/#{name}/headers/get_value.h", "#ifndef __GET_VALUE_H_\n#define __GET_VALUE_H_\n\n/**\n * @func: get_value\n * @brief Returns a greeting as a char*\n * @return char* -> \"Hello, World!\"\n */\nchar *get_value(void);\n\n#endif\n";

        # Create spec files
        Dir.mkdir "#{name}/spec", mode: 751;
        puts "#{"create".colorize(:magenta)} #{name}/spec/#{name}.spec.c";
        File.write "#{name}/spec/#{name}.spec.c", "#include \"#{name}.spec.h\"\n\nint main(void) {\n    char *v = get_value();\n    int res = strcmp(v, \"Hello, World!\");\n\n    if(res == 0) printf(\"Test (1) passed\\n\");\n\n    return 0;\n}\n";
        puts "#{"create".colorize(:magenta)} #{name}/spec/#{name}.spec.h";
        File.write "#{name}/spec/#{name}.spec.h", "#ifndef __#{name.upcase}_SPEC_H_\n#define __#{name.upcase}_SPEC_H_\n\n#include \"../src/#{name}.h\"\n\n#include <string.h>\n\n#endif\n";

        # Sucessful creation
        name;
    end

    ##
    # @message: get_dependencies
    # @brief Get the list of dependencies from the yaml file in a vector
    # @return -> The length of the dependencies vector
    ##
    def get_dependencies
        puts "Emeralds used:";

        deps = yaml.get_dependencies;

        deps.each do |dep|
            list_dep dep;
        end
        
        deps.size;
    end

    ##
    # @message: install_dependencies
    # @brief Installs all missing dependencies for the em library
    # @return -> A flag signaling if the install was successful
    ##
    def install_dependencies
        puts "#{"Resolving".colorize(:magenta)} dependencies...";

        # Recreate libs directory
        FileUtils.rm_rf "libs";
        Dir.mkdir "libs", mode: 751;

        deps = yaml.get_dependencies;
        
        deps.each do |dep|
            install_dep dep;
        end

        true;
    end

    ##
    # @message: compile_as_executable
    # @brief Compile libraries into shared libraries and source code as a binary executable
    # @return -> A flag signaling if the compilation was sucessful
    ##
    def compile_as_executable
        puts "#{"Compiling".colorize(:magenta)} as an executable...";
        puts `#{yaml.get_install_script}`;
        true;
    end

    ##
    # @message: compile_as_library
    # @brief Compile both libraries and source files into shared libraries
    # @return -> A flag signaling if the compilation was sucessful
    ##
    def compile_as_library
        puts "#{"Compiling".colorize(:magenta)} as a library...";
        puts `#{yaml.get_lib_install_script}`;
        true;
    end

    ##
    # @message: run_test_script
    # @brief Runs the test script defined in the em.yml file
    # @return -> A flag signaling if the tests ran successful
    ##
    def run_test_script
        puts "#{"Running".colorize(:magenta)} test...";
        puts `#{yaml.get_test_script}`;
        true;
    end

    ##
    # @message: run_clean_script
    # @brief Runs the clean script defined in the em.yml file
    # @return -> A flag signaling if the clean script was executed
    ##
    def run_clean_script
        puts "#{"Cleaning".colorize(:magenta)} the library files...";
        puts `#{yaml.get_clean_script}`;
        true;
    end

    ##
    # @message: get_em_version
    # @brief Get the em version from the yaml file
    # @return -> The version
    ##
    def get_em_version
        yaml.get_version;
    end
end
