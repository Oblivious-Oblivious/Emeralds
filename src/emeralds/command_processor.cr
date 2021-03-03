require "file_utils"
require "colorize"

require "./yaml_processor"

class Emeralds::CommandProcessor
    getter yaml;

    private def list_dep(dep : String)
        if dep != ""
            parts = dep
                .split(" => ")
                .map(&.lstrip "\"")
                .map(&.rstrip "\"");
            puts "  #{COG} #{parts[0]}";
        end
    end

    private def install_dep(dep : String)
        if dep != ""
            parts = dep
                .split(" => ")
                .map(&.lstrip "\"")
                .map(&.rstrip "\"");
            `git clone https://github.com/#{parts[1]} libs/#{parts[0]}`;

            Dir.cd "libs/#{parts[0]}";
            `em install`;
            `em build lib`
            Dir.cd "../../";
        end
    end

    def initialize
        @yaml = YamlProcessor.new;
    end

    def usage
        puts "emeralds/em [<command>]\n\n";
        puts "Commands:\n";
        puts "    build [app | lib] - Build the application in the `export` directory.\n";
        puts "    clean             - Run the clean script\n";
        puts "    help              - Print this help message.\n";
        puts "    init [name]       - Initialize a new library with an em.yml file.\n";
        puts "    install           - Install dependencies recursively for each included library.\n";
        puts "    list              - List dependencies in the em file.\n";
        puts "    loc               - Count the sloc lines of code in the project\n"
        puts "    test              - Run the script of tests.\n";
        puts "    version           - Print the current version of the emerald.\n";
        exit 0;
    end

    def initialize_em_library(name : String) : String
        puts "Emeralds - Initializing a new project".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        # Create the lib directory
        puts "#{COG} Creating directory: #{name.colorize(:light_green).mode(:bold)}";
        Dir.mkdir name;

        puts "#{COG} Writing initial files:";

        # Write the em.yml file
        puts "  #{ARROW} em.yml";
        File.write "#{name}/em.yml", "name: #{name}\nversion: 0.1.0\n\ndependencies:\n  cSpec: Oblivious-Oblivious/cSpec\n\nlicense: GPLv3\n\napplication: make\nlibrary: make lib\ntest: make test\nclean: make clean\n";

        # Initialize a git directory
        puts "  #{ARROW} .git";
        `git init #{name}/`;

        # Wget a GPLv3 license
        # TODO -> CARE FOR CROSS COMPILATION
        puts "  #{ARROW} LICENSE";
        `wget -O #{name}/LICENSE https://www.gnu.org/licenses/gpl-3.0.txt >/dev/null 2>&1`;

        # Write the makefile
        puts "  #{ARROW} Makefile";
        File.write "#{name}/Makefile", "NAME = #{name}\n\nCC = clang\nOPT = -O2\nVERSION = -std=c11\n\nFLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\nWARNINGS = -Wno-incompatible-pointer-types\nUNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi\nREMOVE_WARNINGS = -Wno-int-conversion\nLIBS = \n\nINPUTFILES = src/$(NAME)/*.c\nINPUT = src/$(NAME).c\nOUTPUT = $(NAME)\n\nTESTFILES = ../src/$(NAME)/*.c\nTESTINPUT = $(NAME).spec.c\nTESTOUTPUT = spec_results\n\nall: default\n\nmake_export:\n\t$(RM) -r export && mkdir export\n\ncopy_headers:\n\tmkdir export/$(NAME) && mkdir export/$(NAME)/headers\n\tcp src/$(NAME)/headers/* export/$(NAME)/headers/\n\tcp src/$(NAME).h export/\n\ndefault: make_export\n\t$(CC) $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT) $(INPUTFILES)\n\tmv $(OUTPUT) export/\n\nlib: make_export copy_headers\n\t$(CC) -c $(OPT) $(VERSION) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) $(INPUTFILES)\n\tar -rcs $(OUTPUT).a *.o\n\tmv $(OUTPUT).a export/lib$(OUTPUT).a\n\t$(RM) -r *.o\n\ntest:\n\tcd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)\n\t@echo\n\t./spec/$(TESTOUTPUT)\n\nspec: test\n\nclean:\n\t$(RM) -r spec/$(TESTOUTPUT)\n\t$(RM) -r export\n\n";

        # Write the .gitignore file
        puts "  #{ARROW} .gitignore";
        File.write "#{name}/.gitignore", "#Prerequisites\n*.d\n\n# Object files\n*.o\n*.ko\n*.obj\n*.elf\n\n# Linker output\n*.ilk\n*.map\n*.exp\n\n# Precompiled Headers\n*.gch\n*.pch\n\n# Executables\n*.exe\n*.out\n*.app\n*.i*86\n*.x86_64\n*.hex\n\n# Debug files\n*.dSYM/\n*.su\n*.idb\n*.pdb\n\n# Kernel Module Compile Results\n# *.mod*\n*.cmd\n.tmp_versions/\nmodules.order\nModule.symvers\nMkfile.old\ndkms.conf\n";

        # Generate a README.md
        puts "  #{ARROW} README.md";
        File.write "#{name}/README.md", "# #{name}\n\nTODO: Write a description here\n\n# Installation\n\nTODO: Write installation instructions here\n\n## Usage\n\nTODO: Write usage instructions here\n\n## Development\n\nTODO: Write development instructions here\n\n## Contributing\n\n1. Fork it (<https://github.com/your-github-user/#{name}/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [YourName](https://github.com/your-github-user) - creator and maintainer\n";

        # Create source directories
        Dir.mkdir "#{name}/src";
        Dir.mkdir "#{name}/src/#{name}";
        Dir.mkdir "#{name}/src/#{name}/headers";

        # Create source files
        puts "  #{ARROW} src"
        puts "    #{ARROW} #{name}.c";
        File.write "#{name}/src/#{name}.c", "#include \"#{name}.h\"\n\nint main(void) {\n    printf(\"%s\\n\", get_value());\n    return 0;\n}\n";
        puts "    #{ARROW} #{name}.h";
        File.write "#{name}/src/#{name}.h", "#ifndef __#{name.upcase}_H_\n#define __#{name.upcase}_H_\n\n#include <stdio.h>\n\n#include \"#{name}/headers/get_value.h\"\n\n#endif\n";
        puts "    #{ARROW} #{name}";
        puts "      #{ARROW} get_value.c";
        File.write "#{name}/src/#{name}/get_value.c", "#include \"headers/get_value.h\"\n\nchar *get_value(void) {\n    return \"Hello, World!\";\n}\n";
        puts "      #{ARROW} headers"
        puts "        #{ARROW} get_value.h";
        File.write "#{name}/src/#{name}/headers/get_value.h", "#ifndef __GET_VALUE_H_\n#define __GET_VALUE_H_\n\n/**\n * @func: get_value\n * @brief Returns a greeting as a char*\n * @return char* -> \"Hello, World!\"\n */\nchar *get_value(void);\n\n#endif\n";

        # Create spec files
        Dir.mkdir "#{name}/spec";
        puts "  #{ARROW} spec"
        puts "    #{ARROW} #{name}.spec.c";
        File.write "#{name}/spec/#{name}.spec.c", "#include \"#{name}.spec.h\"\n\nmodule(T_#{name}, {\n\tdescribe(\"#get_value\", {\n\t\tit(\"returns `Hello, World!`\", {\n\t\t\tassert_that_charptr(get_value() equals to \"Hello, World!\");\n\t\t});\n\t});\n});\n\nspec_suite({\n\tT_#{name}();\n});\n\nspec({\n\trun_spec_suite(\"all\");\n});\n";
        puts "    #{ARROW} #{name}.spec.h";
        File.write "#{name}/spec/#{name}.spec.h", "#ifndef __#{name.upcase}_SPEC_H_\n#define __#{name.upcase}_SPEC_H_\n\n#include \"../src/#{name}.h\"\n#include \"../libs/cSpec/export/cSpec.h\"\n\n#endif\n";
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        # Sucessful creation
        name;
    end

    def get_dependencies
        puts "Emeralds - Em libraries used:".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        deps = yaml.get_dependencies;

        deps.each do |dep|
            list_dep dep;
        end
        
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        deps.size;
    end

    def install_dependencies
        puts "Emeralds - Resolving dependencies...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        # Recreate libs directory
        FileUtils.rm_rf "libs";
        Dir.mkdir "libs";
        
        yaml.get_dependencies.each do |dep|
            install_dep dep;
        end

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def compile_as_executable
        puts "Emeralds - Compiling as an executable...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        puts `#{yaml.get_field "application"}`;

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def compile_as_library
        puts "Emeralds - Compiling as a library...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        puts `#{yaml.get_field "library"}`;

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def run_test_script
        puts "Emeralds - Running tests...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        puts `#{yaml.get_field "test"}`;

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def run_clean_script
        puts "Emeralds - Cleaning the library files...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        puts `#{yaml.get_field "clean"}`;

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def get_em_version
        name = yaml.get_field "name";
        puts "#{name} - Version".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        "#{name} v#{yaml.get_field "version"}";
    end

    def count_lines_of_code
        puts "Counting Lines of Code...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        yaml.get_lines_of_code;
    end
end
