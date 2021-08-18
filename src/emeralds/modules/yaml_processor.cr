require "yaml"

# Helper functions for reading from the em.yml file
module Emeralds::YamlProcessor
    # Secures field from nullity
    # 
    # field -> The specific field we are searching for
    # from -> The yaml object to search from
    # return -> The value of the field
    private def self.read_and_return(field, from) : String
        if from[field].to_s == "nil"
            "";
        else
            from[field].to_s;
        end
    end

    # Secures dependencies field from nullity
    # 
    # from -> The yaml object to read from
    # return -> The value of the dependencies in array form
    private def self.read_and_return_dependencies(from : String) : Array(String)
        if !from || from == ""
            [] of String;
        else
            # Remove brackets and split at commas
            from.to_s
                .lstrip("{")
                .rstrip("}")
                .split(", ");
        end
    end

    # Read a specific field from the yaml file
    #
    # field -> The specific field we are searching for
    # return -> The string field we are searching for
    def self.get_field(field : String) : String
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

            read_and_return field, from: yaml;
        else
            "";
        end
    end

    # Get the dependencies from yaml file
    #
    # return -> The list of dependencies
    def self.get_dependencies : Array(String)
        read_and_return_dependencies from: get_field "dependencies";
    end

    # Get the development dependencies from the yaml file
    #
    # return -> The list of development dependencies
    def self.get_dev_dependencies : Array(String)
        read_and_return_dependencies from: get_field "dev-dependencies";
    end

    # Read all source files and count the lines of codes
    #
    # return -> The total number of files and lines of code
    def self.get_lines_of_code : Array(Int32)
        num = 0;
        loc = 0;

        Dir.glob PATHS do |file|
            num += 1;
            loc += File
                .read(file)
                .split("\n")
                .select { |line| line != "" }
                .size;
        end
        
        [num, loc];
    end

    # Read all dependency source files and count the lines of codes
    #
    # return -> The total number of files and lines of code of libraries
    def self.get_deps_lines_of_code : Array(Int32)
        num = 0;
        loc = 0;

        Dir.glob DEPSPATHS do |file|
            num += 1;
            loc += File
                .read(file)
                .split("\n")
                .select { |line| line != "" }
                .size;
        end
        
        [num, loc];
    end
end
