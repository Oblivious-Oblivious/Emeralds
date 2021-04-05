# A module for setting options and compile flags
# Also can generate a makefile with those options for standalone usage
class Emeralds::CompilerOptionsHelper
    O = {
        "name" => "#{YamlProcessor.new.get_field "name"}",
        "cc" => "clang",
        "debug_opt" => "-Og -g",
        "debug_version" => "-std=c89",
        "debug_flags" => "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic",
        "release_opt" => "-O2",
        "release_version" => "-std=c11",
        "release_flags" => "",
        "warnings" => "-Wno-incompatible-pointer-types",
        "unused_warnings" => "-Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi",
        "remove_warnings" => "-Wno-int-conversion",
        "test_warnings" => "-Wno-implicit-function-declaration",
        "libs" => "-c",
        "deps" => "$(find ./export -name \"*.*o\" >/dev/null 2>&1)",
        "inputfiles" => "src/#{YamlProcessor.new.get_field "name"}/*.c",
        "input" => "src/#{YamlProcessor.new.get_field "name"}.c",
        "output" => "#{YamlProcessor.new.get_field "name"}",
        "testfiles" => "src/#{YamlProcessor.new.get_field "name"}/*.c",
        "testinput" => "spec/#{YamlProcessor.new.get_field "name"}.spec.c",
        "testoutput" => "spec_results"
    };

    # TODO -> MAKE CROSS PLATFORM
    def self.make_export
        `rm -rf export && mkdir export`;
    end
    def self.copy_headers
        `mkdir export/#{O["name"]} && mkdir export/#{O["name"]}/headers`;
        `cp -r src/#{O["name"]}/headers/* export/#{O["name"]}/headers/ >/dev/null 2>&1 || true`;
        `cp src/#{O["name"]}.h export/ >/dev/null 2>&1 || true`;
    end
    def self.move_output_to_export
        `mv #{O["output"]} export/ >/dev/null 2>&1 || true`;
    end
    def self.copy_libraries_to_export
        `mv *.o export/ >/dev/null 2>&1 || true`;
        `mv $(find ./libs -name "*.*o" >/dev/null 2>&1) export/ >/dev/null 2>&1 || true`;
    end

    def self.application_debug
        self.make_export;
        cmd = "#{O["cc"]} #{O["debug_opt"]} #{O["debug_version"]} #{O["debug_flags"]} #{O["warnings"]} #{O["remove_warnings"]} #{O["unused_warnings"]} -o #{O["output"]} #{O["input"]} #{O["inputfiles"]} #{O["deps"]}";
        puts cmd;
        `#{cmd}`;
        self.move_output_to_export;
    end

    def self.application_release
        self.make_export;
        cmd = "#{O["cc"]} #{O["release_opt"]} #{O["release_version"]} #{O["release_flags"]} -o #{O["output"]} #{O["input"]} #{O["inputfiles"]} #{O["deps"]}";
        puts cmd;
        `#{cmd}`;
        self.move_output_to_export;
    end

    def self.library_debug
        self.make_export;
        self.copy_headers;
        cmd = "#{O["cc"]} #{O["debug_opt"]} #{O["debug_version"]} #{O["debug_flags"]} #{O["warnings"]} #{O["remove_warnings"]} #{O["unused_warnings"]} #{O["libs"]} #{O["inputfiles"]}";
        puts cmd;
        `#{cmd}`;
        self.copy_libraries_to_export;
    end

    def self.library_release
        self.make_export;
        self.copy_headers;
        cmd = "#{O["cc"]} #{O["release_opt"]} #{O["release_version"]} #{O["release_flags"]} #{O["libs"]} #{O["inputfiles"]}";
        puts cmd;
        `#{cmd}`;
        self.copy_libraries_to_export;
    end

    def self.test_script
        cmd = "#{O["cc"]} #{O["release_opt"]} #{O["release_version"]} #{O["release_flags"]} #{O["test_warnings"]} -o spec/#{O["testoutput"]} #{O["deps"]} #{O["testfiles"]} #{O["testinput"]}";

        `mkdir export >/dev/null 2>&1 || true`;
        puts cmd;
        `#{cmd}`;

        puts;
        puts "./spec/#{O["testoutput"]}";
        `./spec/#{O["testoutput"]}`;
    end

    def self.clean_script
        puts "rm -rf spec/#{O["testoutput"]}";
        `rm -rf spec/#{O["testoutput"]}`;

        puts "rm -rf export";
        `rm -rf export`;
    end

    # Creates the initial makefile for compilations
    def self.generate_makefile
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
        File.write "Makefile", data;
    end
end
