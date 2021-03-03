require "yaml"

##
# @class: YamlProcessor
# @brief Helper functions for reading from the em.yml file
##
class Emeralds::YamlProcessor
    ##
    # @message: read_and_return
    # @brief Secures field from nullity
    # @param field -> The specific field we are searching for
    # @param from -> The yaml object to search from
    # @return -> The value of the field
    ##
    private def read_and_return(field, from) : String
        if from[field].to_s == "nil"
            "";
        else
            from[field].to_s;
        end
    end

    ##
    # @message: read_and_return_dependencies
    # @brief Secures dependencies field from nullity
    # @param from -> The yaml object to read from
    # @return -> The value of the dependencies in array form
    ##
    private def read_and_return_dependencies(from) : Array(String)
        if !from["dependencies"]
            [] of String;
        else
            # Remove brackets and split at commas
            from["dependencies"]
                .to_s
                .lstrip("{")
                .rstrip("}")
                .split(", ");
        end
    end

    ##
    # @message: get_dependencies
    # @brief Get the dependencies from yaml file
    # @return -> The list of dependencies
    ##
    def get_dependencies : Array(String)
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;
            
            read_and_return_dependencies from: yaml;
        else
            [] of String;
        end
    end

    ##
    # @message: get_field
    # @brief Read a specific field from the yaml file
    # @return -> The string field we are searching for
    ##
    def get_field(field : String ) : String
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

            read_and_return field, from: yaml;
        else
            "";
        end
    end

    ##
    # @message: get_lines_of_code
    # @brief Read all source files and count the lines of codes
    # @return -> The total number of files nad lines of code
    ##
    def get_lines_of_code : Array(Int32)
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
end
