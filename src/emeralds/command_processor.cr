require "file_utils"
require "colorize"

# Bundles up the code for all commands
class Emeralds::CommandProcessor
    # Split The YAML object on the "=>" to get the github repository
    #
    # from -> The string containing the name and link of the current dependencies to draw
    # return -> The formatted array of name and github link
    private def get_parts(from : String) : Array(String)
        from.split(" => ")
           .map(&.lstrip "\"")
           .map(&.rstrip "\"");
    end

    # List a dependency as formatted text
    #
    # dep -> The name of the dependecy to list
    private def list_dep(dep : String)
        parts = get_parts from: dep;
        puts "  #{COG} #{parts[0]}";
    end

    # Install a dependency and its dependencies
    #
    # dep -> The name of the dependecy to install
    private def install_dep(dep : String)
        parts = get_parts from: dep;

        # Remove before installing or re-installing
        FileUtils.rm_rf "libs/#{parts[0]}";

        puts " #{COG} Installing `#{parts[0]}`";
        `git clone https://github.com/#{parts[1]} libs/#{parts[0]} 2>&1`;
        Dir.cd "libs/#{parts[0]}";
        `rm -rf .git*`;

        `em install`;
        `em build lib release`;

        Dir.cd "../../";
    end

    # Outputs example usage for emeralds
    def usage
        puts "emeralds/em [<command>]\n\n";
        puts "Commands:\n";
        puts "    build [app | lib] [debug | release] - Build the application in the `export` directory.\n";
        puts "    clean                               - Run the clean script\n";
        puts "    help                                - Print this help message.\n";
        puts "    init [name]                         - Initialize a new library with an em.yml file.\n";
        puts "    install [ | dev]                    - Install dependencies recursively for each included library.\n";
        puts "    list                                - List dependencies in the em file.\n";
        # puts "    makefile                            - Generate a makefile for independent compilation\n";
        puts "    loc [ | deps]                       - Count the sloc lines of code in the project\n"
        puts "    test                                - Run the script of tests.\n";
        puts "    version                             - Print the current version of the emerald.\n";
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
    end

    # Initialize a new emfile with the name specified
    #
    # name -> The name of the new library
    # return -> The name, if the library was created successfully
    def initialize_em_library(name : String) : String
        Emeralds::FileCreatorHelper.name = name;
        Emeralds::FileCreatorHelper.create_lib_directory;

        puts "#{COG} Writing initial files:";
        Emeralds::FileCreatorHelper.write_em_file;
        Emeralds::FileCreatorHelper.initialize_git_directory;
        Emeralds::FileCreatorHelper.wget_a_gplv3_license;
        Emeralds::FileCreatorHelper.write_gitignore_file;
        Emeralds::FileCreatorHelper.generate_readme;
        Emeralds::FileCreatorHelper.create_source_directories;
        Emeralds::FileCreatorHelper.create_source_files;
        Emeralds::FileCreatorHelper.create_spec_files;

        # Sucessful creation
        name;
    end

    # Get the list of dependencies from the yaml file in a vector
    #
    # return -> The length of the dependencies vector
    def get_dependencies
        deps = Emeralds::YamlProcessor.get_dependencies;
        deps.each do |dep|
            list_dep dep if dep != "";
        end

        dev_deps = Emeralds::YamlProcessor.get_dev_dependencies;
        dev_deps.each do |dep|
            list_dep dep if dep != "";
        end

        deps.size + dev_deps.size;
    end

    # Installs all missing dependencies for the em library
    #
    # return -> A flag signaling if the install was successful
    def install_dependencies
        # Recreate libs directory
        unless Dir.exists? "libs"
            Dir.mkdir "libs";
        end

        Emeralds::YamlProcessor.get_dependencies.each do |dep|
            install_dep dep unless dep == "";
        end

        true;
    end

    # Installs all missing development dependencies for the em library
    #
    # return -> A flag signaling if the install was successful
    def install_dev_dependencies
        # Recreate libs directory
        unless Dir.exists? "libs"
            Dir.mkdir "libs";
        end

        Emeralds::YamlProcessor.get_dev_dependencies.each do |dep|
            install_dep dep unless dep == "";
        end

        true;
    end

    # Compile libraries into shared libraries and source code as a binary executable
    #
    # return -> A flag signaling if the compilation was sucessful
    def compile_as_executable(mode : String)
        override = Emeralds::YamlProcessor.get_field "build";
        if override.strip != ""
            puts override;
            `#{override}`;
        elsif mode == "release"
            Emeralds::CompilerOptionsHelper.application_release;
        else
            Emeralds::CompilerOptionsHelper.application_debug;
        end
        true;
    end

    # Compile both libraries and source files into shared libraries
    #
    # return -> A flag signaling if the compilation was sucessful
    def compile_as_library(mode : String)
        override = Emeralds::YamlProcessor.get_field "build";
        if override.strip != ""
            puts override;
            `#{override}`;
        elsif mode == "release"
            Emeralds::CompilerOptionsHelper.library_release;
        else
            Emeralds::CompilerOptionsHelper.library_debug;
        end
        true;
    end

    # Runs the test script defined in the em.yml file
    #
    # return -> A flag signaling if the tests ran successful
    def run_test_script
        Emeralds::CompilerOptionsHelper.test_script;
    end

    # Runs the clean script defined in the em.yml file
    #
    # return -> A flag signaling if the clean script was executed
    def run_clean_script
        Emeralds::CompilerOptionsHelper.clean_script;
    end

    # Get the em version from the yaml file
    #
    # return -> The version
    def get_em_version
        "#{Emeralds::YamlProcessor.get_field "name"} v#{Emeralds::YamlProcessor.get_field "version"}";
    end

    # Count the number of lines of code
    #
    # return -> loc
    def count_lines_of_code
        Emeralds::YamlProcessor.get_lines_of_code;
    end

    # Count the number of lines of code in dependencies
    #
    # return -> loc of libs
    def count_deps_lines_of_code
        Emeralds::YamlProcessor.get_deps_lines_of_code;
    end

    # Generates a makefile for compiling apps without Emeralds
    def generate_makefile
        Emeralds::CompilerOptionsHelper.generate_makefile;
    end
end
