# Helper functions for reading from the em.yml file
module Emeralds::YamlReader
  # Secures field from nullity
  #
  # field -> The specific field we are searching for
  # from -> The yaml object to search from
  # return -> The value of the field
  private def self.read_and_return(field, from)
    from[field].to_s;
  rescue
    "";
  end

  # Secures dependencies field from nullity
  #
  # from -> The yaml object to read from
  # return -> The value of the dependencies in array form
  private def self.read_and_return_dependencies(from)
    deps = get_field from;
    if deps == ""
      [] of String;
    else
      deps
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
    read_and_return_dependencies from: "dependencies";
  end

  # Get the development dependencies from the yaml file
  #
  # return -> The list of development dependencies
  def self.get_dev_dependencies
    read_and_return_dependencies from: "dev-dependencies";
  end
end
