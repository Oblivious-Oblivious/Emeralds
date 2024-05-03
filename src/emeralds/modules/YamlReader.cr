# Helper functions for reading from the em.yml file
module Emeralds::YamlReader
  # Split The YAML object on the "=>" to get the github repository
  #
  # from -> The string containing the name and link of the current dependencies to draw
  # return -> The formatted array of name and github link
  private def self.get_parts(from)
    from
      .split(" => ")
      .map(&.lstrip "\"")
      .map(&.rstrip "\"");
  end

  # Install a dependency and its dependencies
  #
  # dep -> The name of the dependecy to install
  def self.install_dep(dep)
    parts = get_parts from: dep;
    TerminalHandler.rm (File.join "libs", "#{parts[0]}");
    puts " #{Emeralds.cog} Installing `#{parts[0]}`";

    TerminalHandler.git_clone "https://github.com/#{parts[1]}", (File.join "libs", "#{parts[0]}");
    Dir.cd (File.join "libs", "#{parts[0]}");
    TerminalHandler.generic_cmd "em install";
    TerminalHandler.generic_cmd "em build lib release";
    FileHandler.delete_excluded_paths ".", ["export", "libs"];

    # TODO - TerminalHanlder.rm Not working with dotfiles.
    `rm -rf libs/#{parts[0]}/.git*`;
    `rm -rf libs/#{parts[0]}/.clang*`;
    Dir.cd (File.join "..", "..");
  end

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

  # List a dependency as formatted text
  #
  # dep -> The name of the dependecy to list
  def self.list_dep(dep)
    parts = get_parts from: dep;
    puts "  #{Emeralds.cog} #{parts[0]}";
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
