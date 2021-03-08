require "file_utils"
require "colorize"

require "./yaml_processor"
require "./file_creator_helper"

class Emeralds::CommandProcessor
    getter :yaml;

    private def get_parts(from : String) : Array(String)
        from.split(" => ")
           .map(&.lstrip "\"")
           .map(&.rstrip "\"");
    end

    private def list_dep(dep : String)
        parts = get_parts from: dep;
        puts "  #{COG} #{parts[0]}";
    end

    private def install_dep(dep : String)
        parts = get_parts from: dep;
        `git clone https://github.com/#{parts[1]} libs/#{parts[0]}`;

        # TODO -> REMOVE BEFORE INSTALLING OR RE-INSTALLING
        Dir.cd "libs/#{parts[0]}";
        `em install`;
        `em build lib`
        Dir.cd "../../";
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
        puts "    install [ | dev]  - Install dependencies recursively for each included library.\n";
        puts "    list              - List dependencies in the em file.\n";
        puts "    loc               - Count the sloc lines of code in the project\n"
        puts "    test              - Run the script of tests.\n";
        puts "    version           - Print the current version of the emerald.\n";
        exit 0;
    end

    def initialize_em_library(name : String) : String
        puts "Emeralds - Initializing a new project".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        fch = FileCreatorHelper.new name;
        fch.create_lib_directory;

        puts "#{COG} Writing initial files:";
        fch.write_em_file;
        fch.initialize_git_directory;
        fch.wget_a_gplv3_license;
        fch.write_makefile;
        fch.write_gitignore_file;
        fch.generate_readme;
        fch.create_source_directories;
        fch.create_source_files;
        fch.create_spec_files;
        
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        # Sucessful creation
        name;
    end

    def get_dependencies
        puts "Emeralds - Em libraries used:".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

        deps = yaml.get_dependencies;

        deps.each do |dep|
            list_dep dep if dep != "";
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
            install_dep dep if dep != "";
        end

        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        true;
    end

    def install_dev_dependencies
        puts "Emeralds - Resolving development dependencies...".colorize(:white).mode(:bold);
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
        
        yaml.get_dev_dependencies.each do |dep|
            install_dep dep if dep != "";
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
