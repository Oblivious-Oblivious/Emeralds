# Helper module of bundled functions for writing initial files
class Emeralds::FileCreatorHelper
    getter :name;

    def initialize(
        @name : String
    )
    end

    # Creates the library directories
    def create_lib_directory
        puts "#{COG} Creating directory: #{name.colorize(:light_green).mode(:bold)}";
        Dir.mkdir name;
    end

    # Creates the initial emfile
    def write_em_file
        puts "  #{ARROW} em.yml";
        data = String.build do |data|
            data << "name: #{name}\n";
            data << "version: 0.1.0\n\n";

            data << "dependencies:\n\n";

            data << "dev-dependencies:\n";
            data << "  cSpec: Oblivious-Oblivious/cSpec\n\n";

            data << "license: GPLv3\n\n";

            data << "application_debug: make app_debug\n";
            data << "application_release: make app_release\n";
            data << "library_debug: make lib_debug\n";
            data << "library_release: make lib_release\n";
            data << "test: make test\n";
            data << "clean: make clean\n";
        end
        File.write "#{name}/em.yml", data;
    end

    # Creates a new git repository
    def initialize_git_directory
        puts "  #{ARROW} .git";
        `git init #{name}/`;
    end

    # Resolves a GPLv3 license from the web
    # TODO -> USES WGET MAKE SURE IT IS INSTALLED ON TARGET MACHINE
    def wget_a_gplv3_license
        puts "  #{ARROW} LICENSE";
        `wget -O #{name}/LICENSE https://www.gnu.org/licenses/gpl-3.0.txt >/dev/null 2>&1`;
    end

    # Creates the initial makefile for compilations
    def write_makefile
        puts "  #{ARROW} Makefile";
        data = String.build do |data|
            data << "NAME = #{name}\n\n";
            data << "CC = clang\n";

            data << "DEBUG_OPT = -Og -g\n";
            data << "DEBUG_VERSION = -std=c89\n\n";
            data << "DEBUG_FLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\n";
            data << "RELEASE_OPT = -O2\n";
            data << "RELEASE_VERSION = -std=c11\n\n";
            data << "RELEASE_FLAGS =\n";

            data << "WARNINGS = -Wno-incompatible-pointer-types\n";
            data << "UNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi\n";
            data << "REMOVE_WARNINGS = -Wno-int-conversion\n";
            data << "TEST_WARNINGS = -Wno-implicit-function-declaration\n";
            data << "LIBS = -c\n";
            data << "DEPS = $(shell find ./export -name \"*.*o\")\n\n";

            data << "INPUTFILES = src/$(NAME)/*.c\n";
            data << "INPUT = src/$(NAME).c\n";
            data << "OUTPUT = $(NAME)\n\n";

            data << "TESTFILES = src/$(NAME)/*.c\n";
            data << "TESTINPUT = spec/$(NAME).spec.c\n";
            data << "TESTOUTPUT = spec_results\n\n";

            data << "all: app_debug\n\n";

            data << "make_export:\n\t";
                data << "$(RM) -r export && mkdir export\n\n";

            data << "copy_headers:\n\t";
                data << "mkdir export/$(NAME) && mkdir export/$(NAME)/headers\n\t";
                data << "cp -r src/$(NAME)/headers/* export/$(NAME)/headers/ >/dev/null 2>&1 || true\n\t";
                data << "cp src/$(NAME).h export/ >/dev/null 2>&1 || true\n\n";
            
            data << "app_debug: make_export\n\t";
                data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
                data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";
            
            data << "app_release: make_export\n\t";
                data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
                data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";

            data << "lib_debug: make_export copy_headers\n\t";
                data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) $(INPUTFILES)\n\t";
                data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
                data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

            data << "lib_release: make_export copy_headers\n\t";
                data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(LIBS) $(INPUTFILES)\n\t";
                data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
                data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

            data << "test:\n\t";
                data << "mkdir export >/dev/null 2>&1 || true; $(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(TEST_WARNINGS) -o spec/$(TESTOUTPUT) $(DEPS) $(TESTFILES) $(TESTINPUT)\n\t";
                data << "@echo\n\t";
                data << "./spec/$(TESTOUTPUT)\n\n";

            data << "spec: test\n\n";

            data << "clean:\n\t";
                data << "$(RM) -r spec/$(TESTOUTPUT)\n\t";
                data << "$(RM) -r export\n\n";
        end
        File.write "#{name}/Makefile", data;
    end

    # Creates the .gitignore file
    def write_gitignore_file
        puts "  #{ARROW} .gitignore";
        data = String.build do |data|
            data << "#Prerequisites\n";
            data << "*.d\n\n";

            data << "# Object files\n";
            data << "*.o\n";
            data << "*.ko\n";
            data << "*.obj\n";
            data << "*.elf\n\n";

            data << "# Linker output\n";
            data << "*.ilk\n";
            data << "*.map\n";
            data << "*.exp\n\n";

            data << "# Precompiled Headers\n";
            data << "*.gch\n";
            data << "*.pch\n\n";

            data << "# Executables\n";
            data << "*.exe\n";
            data << "*.out\n";
            data << "*.app\n";
            data << "*.i*86\n";
            data << "*.x86_64\n";
            data << "*.hex\n\n";

            data << "# Debug files\n";
            data << "*.dSYM/\n";
            data << "*.su\n";
            data << "*.idb\n";
            data << "*.pdb\n\n";

            data << "# Kernel Module Compile Results\n";
            data << "# *.mod*\n";
            data << "*.cmd\n";
            data << ".tmp_versions/\n";
            data << "modules.order\n";
            data << "Module.symvers\n";
            data << "Mkfile.old\n";
            data << "dkms.conf\n\n";

            data << "libs/\n";
        end
        File.write "#{name}/.gitignore", data;
    end

    # Creates the initial README.md file
    def generate_readme
        puts "  #{ARROW} README.md";
        data = String.build do |data|
            data << "# #{name}\n\n";

            data << "TODO: Write a description here\n\n";

            data << "# Installation\n\n";

            data << "TODO: Write installation instructions here\n\n";

            data << "## Usage\n\n";

            data << "TODO: Write usage instructions here\n\n";

            data << "## Development\n\n";

            data << "TODO: Write development instructions here\n\n";

            data << "## Contributing\n\n";

            data << "1. Fork it (<https://github.com/your-github-user/#{name}/fork>)\n";
            data << "2. Create your feature branch (`git checkout -b my-new-feature`)\n";
            data << "3. Commit your changes (`git commit -am 'Add some feature'`)\n";
            data << "4. Push to the branch (`git push origin my-new-feature`)\n";
            data << "5. Create a new Pull Request\n\n";

            data << "## Contributors\n\n";

            data << "- [YourName](https://github.com/your-github-user) - creator and maintainer\n";
            data << "";
        end
        File.write "#{name}/README.md", data;
    end

    # Creates the dummy source directory
    def create_source_directories
        Dir.mkdir "#{name}/src";
        Dir.mkdir "#{name}/src/#{name}";
        Dir.mkdir "#{name}/src/#{name}/headers";
    end

    # Create a dummy main source file
    private def create_src_main
        puts "    #{ARROW} #{name}.c";
        data = String.build do |data|
            data << "#include \"#{name}.h\"\n\n";

            data << "int main(void) {\n";
            data << "    printf(\"%s\\n\", get_value());\n";
            data << "    return 0;\n";
            data << "}\n";
        end
        File.write "#{name}/src/#{name}.c", data;
    end

    # Create a dummy lib header file
    private def create_src_header
        puts "    #{ARROW} #{name}.h";
        data = String.build do |data|
            data << "#ifndef __#{name.gsub("-", "_").upcase}_H_\n"
            data << "#define __#{name.gsub("-", "_").upcase}_H_\n\n";
            
            data << "#include <stdio.h>\n\n";
            
            data << "#include \"#{name}/headers/get_value.h\"\n\n";
            
            data << "#endif\n";
        end
        File.write "#{name}/src/#{name}.h", data;
    end

    # Create a dummy lib source file
    private def create_value_main
        puts "      #{ARROW} get_value.c";
        data = String.build do |data|
            data << "#include \"headers/get_value.h\"\n\n";

            data << "char *get_value(void) {\n";
            data << "    return \"Hello, World!\";\n";
            data << "}\n";
        end
        File.write "#{name}/src/#{name}/get_value.c", data;
    end

    # Creates a dummy lib header file
    private def create_value_header
        puts "        #{ARROW} get_value.h";
        data = String.build do |data|
            data << "#ifndef __GET_VALUE_H_\n";
            data << "#define __GET_VALUE_H_\n\n";

            data << "/**\n";
            data << " * @func: get_value\n";
            data << " * @brief Returns a greeting as a char*\n";
            data << " * @return char* -> \"Hello, World!\"\n";
            data << " */\n";
            data << "char *get_value(void);\n\n";

            data << "#endif\n";
        end
        File.write "#{name}/src/#{name}/headers/get_value.h", data;
    end
    def create_source_files
        puts "  #{ARROW} src";
        create_src_main;
        create_src_header;
        
        puts "    #{ARROW} #{name}";
        create_value_main;
        
        puts "      #{ARROW} headers";
        create_value_header;
    end

    # Cretes a dummy spec file using cSpec
    def create_spec_main
        puts "    #{ARROW} #{name}.spec.c";
        data = String.build do |data|
            data << "#include \"#{name}.spec.h\"\n\n";

            data << "module(T_#{name.gsub("-", "_")}, {\n";
            data << "    describe(\"#get_value\", {\n";
            data << "        it(\"returns `Hello, World!`\", {\n";
            data << "            assert_that_charptr(get_value() equals to \"Hello, World!\");\n";
            data << "        });\n";
            data << "    });\n";
            data << "});\n\n";

            data << "spec_suite({\n";
            data << "    T_#{name.gsub("-", "_")}();\n";
            data << "});\n\n";

            data << "spec({\n";
            data << "    run_spec_suite(\"all\");\n";
            data << "});\n";
        end
        File.write "#{name}/spec/#{name}.spec.c", data;
    end

    # Cretes a dummy cSpec helper file
    def create_spec_header
        puts "    #{ARROW} #{name}.spec.h";
        data = String.build do |data|
            data << "#ifndef __#{name.gsub("-", "_").upcase}_SPEC_H_\n";
            data << "#define __#{name.gsub("-", "_").upcase}_SPEC_H_\n\n";

            data << "#include \"../src/#{name}.h\"\n";
            data << "#include \"../libs/cSpec/export/cSpec.h\"\n\n";

            data << "#endif\n";
        end
        File.write "#{name}/spec/#{name}.spec.h", data;
    end

    # Calls the create methods
    def create_spec_files
        Dir.mkdir "#{name}/spec";
        puts "  #{ARROW} spec";
        create_spec_main;
        create_spec_header;
    end
end
