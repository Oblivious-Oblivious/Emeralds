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
    # @message: get_version
    # @brief Read the version field from the yaml file
    # @return -> The version as a string object
    ##
    def get_version : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["version"].to_s == "nil"
            "";
        else
            yaml["version"].to_s;
        end
    end

    ##
    # @message: get_install_script
    # @brief Get the install script from yaml file
    # @return -> The install field
    ##
    def get_install_script : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["install"].to_s == "nil"
            "";
        else
            yaml["install"].to_s;
        end
    end

    ##
    # @message: get_lib_install_script
    # @brief Get the lib install script from yaml file
    # @return -> The lib_install field
    ##
    def get_lib_install_script : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["lib_install"].to_s == "nil"
            "";
        else
            yaml["lib_install"].to_s;
        end
    end

    ##
    # @message: get_postinstall_script
    # @brief Get the postinstall script from yaml file
    # @return -> The postinstall field
    ##
    def get_postinstall_script : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["postinstall"].to_s == "nil"
            "";
        else
            yaml["postinstall"].to_s;
        end
    end

    ##
    # @message: get_test_script
    # @brief Get the test script from yaml file
    # @return -> The test field
    ##
    def get_test_script : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["test"].to_s == "nil"
            "";
        else
            yaml["test"].to_s;
        end
    end

    ##
    # @message: get_clean_script
    # @brief Get the clean sript from the yaml file
    # @return -> The clean field
    ##
    def get_clean_script : String
        yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

        if yaml["clean"].to_s == "nil"
            "";
        else
            yaml["clean"].to_s;
        end
    end
end
