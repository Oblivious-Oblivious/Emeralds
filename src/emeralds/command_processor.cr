require "file_utils";
require "colorize";

# Bundles up the code for all commands
class Emeralds::CommandProcessor
  # Split The YAML object on the "=>" to get the github repository
  #
  # from -> The string containing the name and link of the current dependencies to draw
  # return -> The formatted array of name and github link
  def self.get_parts(from)
    from
      .split(" => ")
      .map(&.lstrip "\"")
      .map(&.rstrip "\"");
  end

  # Install a dependency and its dependencies
  #
  # dep -> The name of the dependecy to install
  def self.install_dep(dep)
    parts = Emeralds::CommandProcessor.get_parts from: dep;
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
  def self.usage
    puts "emeralds/em [<command>]\n\n";
    puts "Commands:\n";
    puts "    build [app | lib] [debug | release] - Build the application in the `export` directory.\n";
    puts "    clean                               - Run the clean script\n";
    puts "    help                                - Print this help message.\n";
    puts "    init [name]                         - Initialize a new library with an em.yml file.\n";
    puts "    install [ | dev]                    - Install dependencies recursively for each included library.\n";
    puts "    list                                - List dependencies in the em file.\n";
    # TODO Fix makefile
    # puts "    makefile                            - Generate a makefile for independent compilation\n";
    puts "    loc [ | deps]                       - Count the sloc lines of code in the project\n";
    puts "    test                                - Run the script of tests.\n";
    puts "    version                             - Print the current version of the emerald.\n";
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  # Tries to execute the override compilation directive if it exists
  #
  # returns -> true if the override was ran else false
  def self.try_override_command
    override = Emeralds::YamlHelper.get_field "build";
    if override.strip != ""
      puts override;
      `#{override}`;
      true;
    else
      false;
    end
  end

  # TODO - Compile into static libraries instead of shared
end
