# Helper functions for reading from the em.yml file
module Emeralds::YamlReader
  # Secures field from nullity
  #
  # field -> The specific field we are searching for
  # from -> The yaml object to search from
  # return -> The value of the field
  private def self.read_and_return(field, from)
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
  private def self.read_and_return_dependencies(from)
    if !from || from == ""
      [] of String;
    else
      from
        .to_s
        .lstrip("{")
        .rstrip("}")
        .split(", ");
    end
  end

  # Read a specific field from the yaml file
  #
  # field -> The specific field we are searching for
  # return -> The string field we are searching for
  def self.get_field(field)
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
  def self.get_dependencies
    read_and_return_dependencies from: get_field "dependencies";
  end

  # Get the development dependencies from the yaml file
  #
  # return -> The list of development dependencies
  def self.get_dev_dependencies
    read_and_return_dependencies from: get_field "dev-dependencies";
  end
end
