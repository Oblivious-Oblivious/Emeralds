require "yaml"

##
# @class: YamlProcessor
# @brief Helper functions for reading from the em.yml file
##
class Emeralds::YamlProcessor
    ##
    # @message: get_dependencies
    # @brief Get the dependencies from yaml file
    # @return -> The list of dependencies
    ##
    def get_dependencies : Array(String)
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;
            if !yaml["dependencies"]
                [] of String;
            else
                # Remove brackets and split at commas
                yaml["dependencies"].to_s.lstrip("{").rstrip("}").split(", ");
            end
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
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml[field].to_s == "nil"
            "";
        else
            yaml[field].to_s;
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

        Dir.glob "src/**/*.c" do |file|
            num += 1;
            loc += File.read(file).split("\n").select { |line| line != "" }.size;
        end

        Dir.glob "src/**/*.h" do |file|
            num += 1;
            loc += File.read(file).split("\n").select { |line| line != "" }.size;
        end

        Dir.glob "spec/**/*.c" do |file|
            num += 1;
            loc += File.read(file).split("\n").select { |line| line != "" }.size;
        end

        Dir.glob "spec/**/*.h" do |file|
            num += 1;
            loc += File.read(file).split("\n").select { |line| line != "" }.size;
        end

        [num, loc];
    end
end
