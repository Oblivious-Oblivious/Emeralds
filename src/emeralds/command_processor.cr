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

        # Remove before installing or re-installing
        FileUtils.rm_rf "libs/#{parts[0]}";

        puts " #{COG} Installing `#{parts[0]}`";
        `git clone https://github.com/#{parts[1]} libs/#{parts[0]} 2>&1`;
        Dir.cd "libs/#{parts[0]}";
        `rm -rf .git*`;

        `em install`;
        `em build lib`;

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
        puts "    loc [ | deps]     - Count the sloc lines of code in the project\n"
        puts "    test              - Run the script of tests.\n";
        puts "    version           - Print the current version of the emerald.\n";
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
    end

    def initialize_em_library(name : String) : String
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

        # Sucessful creation
        name;
    end

    def get_dependencies
        deps = yaml.get_dependencies;
        deps.each do |dep|
            list_dep dep if dep != "";
        end

        dev_deps = yaml.get_dev_dependencies;
        dev_deps.each do |dep|
            list_dep dep if dep != "";
        end

        deps.size + dev_deps.size;
    end

    def install_dependencies
        # Recreate libs directory
        unless Dir.exists? "libs"
            Dir.mkdir "libs";
        end

        yaml.get_dependencies.each do |dep|
            install_dep dep unless dep == "";
        end

        true;
    end

    def install_dev_dependencies
        # Recreate libs directory
        unless Dir.exists? "libs"
            Dir.mkdir "libs";
        end

        yaml.get_dev_dependencies.each do |dep|
            install_dep dep unless dep == "";
        end

        true;
    end

    def compile_as_executable
        puts `#{yaml.get_field "application"}`;
        true;
    end

    def compile_as_library
        puts `#{yaml.get_field "library"}`;
        true;
    end

    def run_test_script
        puts `#{yaml.get_field "test"}`;
        true;
    end

    def run_clean_script
        puts `#{yaml.get_field "clean"}`;
        true;
    end

    def get_em_version
        name = yaml.get_field "name";
        "#{name} v#{yaml.get_field "version"}";
    end

    def count_lines_of_code
        yaml.get_lines_of_code;
    end

    def count_deps_lines_of_code
        yaml.get_deps_lines_of_code;
    end
end
