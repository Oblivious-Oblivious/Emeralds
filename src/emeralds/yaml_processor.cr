require "yaml"

class Emerald::YamlProcessor
    ##
    # @message: get_dependencies
    # @brief Get the dependencies from yaml file
    # @return -> The list of dependencies
    ##
    def get_dependencies : Array(String)
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if !yaml["dependencies"]
            [] of String;
        else
            # Remove brackets and split at commas
            yaml["dependencies"].to_s.lstrip("{").rstrip("}").split(", ");
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
end
