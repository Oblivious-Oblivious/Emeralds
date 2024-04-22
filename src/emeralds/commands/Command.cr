# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
  @name : String = "";
  getter :name;

  # Contains the informational message for the user while performing an Emerald command
  #
  # return -> The string to display
  abstract def message;

  # A block of code to be executed for the command
  #
  # return -> The code block
  abstract def block;

  # A random banner for enclosing output more clearly
  #
  # return -> The actual banner string
  private def banner
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  # Counts the elapsed time between execution blocks
  #
  # return -> A detailed string explained the time taken
  private def elapsed_time(elapsed)
    "All done in #{elapsed
      .total_seconds
      .format(decimal_places: 3)
    } seconds"
      .colorize(:white)
      .mode(:bold);
  end

  private def make_export
    `rm -rf export && mkdir export`;
  end

  private def copy_headers
    `mkdir export/#{Emeralds::OPT["name"]} && mkdir export/#{Emeralds::OPT["name"]}/headers`;
    `cp -r src/#{Emeralds::OPT["name"]}/headers/* export/#{Emeralds::OPT["name"]}/headers/ >/dev/null 2>&1 || true`;
    `cp src/#{Emeralds::OPT["name"]}.h export/ >/dev/null 2>&1 || true`;
  end

  private def move_output_to_export
    `mv #{Emeralds::OPT["output"]} export/ >/dev/null 2>&1 || true`;
  end

  private def copy_libraries_to_export
    `mv *.o export/ >/dev/null 2>&1 || true`;
    `cp -r $(find ./libs -name "*.*o") export/ >/dev/null 2>&1 || true`;
  end

  private def library_release
    make_export;
    copy_headers;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["libs"]} #{Emeralds::OPT["inputfiles"]} 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    copy_libraries_to_export;
  end

  # Split The YAML object on the "=>" to get the github repository
  #
  # from -> The string containing the name and link of the current dependencies to draw
  # return -> The formatted array of name and github link
  private def get_parts(from)
    from
      .split(" => ")
      .map(&.lstrip "\"")
      .map(&.rstrip "\"");
  end

  # Install a dependency and its dependencies
  #
  # dep -> The name of the dependecy to install
  private def install_dep(dep)
    parts = get_parts from: dep;
    FileUtils.rm_rf "libs/#{parts[0]}";
    puts " #{COG} Installing `#{parts[0]}`";

    `git clone https://github.com/#{parts[1]} libs/#{parts[0]} 2>&1`;
    Dir.cd "libs/#{parts[0]}";
    `rm -rf .git*`;
    `em install`;
    `em build lib release`;
    Dir.cd "../../";
  end

  # Tries to execute the override compilation directive if it exists
  #
  # returns -> true if the override was ran else false
  private def try_override_command
    override = Emeralds::YamlReader.get_field "build";
    if override.strip != ""
      puts override;
      `#{override}`;
      true;
    else
      false;
    end
  end

  # Outputs example usage for emeralds
  private def usage
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

  # TODO - Compile into static libraries instead of shared

  # Main method that runs and times the command block.
  def run
    puts message.colorize(:white).mode(:bold);
    puts banner;

    elapsed = Time.measure { block.call; };

    puts banner;
    puts elapsed_time elapsed;
  end
end
