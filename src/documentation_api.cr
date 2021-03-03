# Defines constants such as version and CLI logger customizations
module Emeralds
end

# Helper functions for reading from the em.yml file
class Emeralds::YamlProcessor
    # Secures field from nullity
    # 
    # field -> The specific field we are searching for
    # from -> The yaml object to search from
    # return -> The value of the field
    def read_and_return(field : String, from : Hash(Path, Path)) : String
        "";
    end

    # Secures dependencies field from nullity
    # 
    # from -> The yaml object to read from
    # return -> The value of the dependencies in array form
    private def read_and_return_dependencies(from : Hash(Path, Path)) : Array(String)
        [] of String;
    end

    # Get the dependencies from yaml file
    #
    # return -> The list of dependencies
    def get_dependencies : Array(String)
        [] of String;
    end

    # Read a specific field from the yaml file
    #
    # field -> The specific field we are searching for
    # return -> The string field we are searching for
    def get_field(field : String ) : String
        "";
    end

    # Read all source files and count the lines of codes
    #
    # return -> The total number of files nad lines of code
    def get_lines_of_code : Array(Int64)
        [] of Int64;
    end
end

# Bundles up the code for all commands
class Emeralds::CommandProcessor
    # List a dependency as formatted text
    #
    # dep -> The name of the dependecy to list
    private def list_dep(dep : String)
    end

    # Install a dependency and its dependencies
    #
    # dep -> The name of the dependecy to install
    private def install_dep(dep : String)
    end

    # Outputs example usage for emeralds
    def usage
    end

    # Initialize a new emfile with the name specified
    #
    # name -> The name of the new library
    # return -> The name, if the library was created successfully
    def initialize_em_library(name : String) : String
        "";
    end

    # Get the list of dependencies from the yaml file in a vector
    #
    # return -> The length of the dependencies vector
    def get_dependencies : Int32
        0;
    end

    # Installs all missing dependencies for the em library
    #
    # return -> A flag signaling if the install was successful
    def install_dependencies : Bool
        false;
    end

    # Compile libraries into shared libraries and source code as a binary executable
    #
    # return -> A flag signaling if the compilation was sucessful
    def compile_as_executable : Bool
        false;
    end

    # Compile both libraries and source files into shared libraries
    #
    # return -> A flag signaling if the compilation was sucessful
    def compile_as_library : Bool
        false;
    end

    # Runs the test script defined in the em.yml file
    #
    # return -> A flag signaling if the tests ran successful
    def run_test_script : Bool
        false;
    end

    # Runs the clean script defined in the em.yml file
    #
    # return -> A flag signaling if the clean script was executed
    def run_clean_script : Bool
        false;
    end

    # Get the em version from the yaml file
    #
    # return -> The version
    def get_em_version : String
        "";
    end

    # Count the number of lines of code
    #
    # return -> loc
    def count_lines_of_code : Array(Int64)
        [] of Int64;
    end
end

# Defines the main functionality when running the system
class Emeralds::Main
    # Runs a the progeram that parses the option
    # TODO Use an option parser
    def run
    end
end
