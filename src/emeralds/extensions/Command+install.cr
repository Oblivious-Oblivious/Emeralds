abstract class Emeralds::Command
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
    TerminalHandler.rm "libs/#{parts[0]}";
    puts " #{COG} Installing `#{parts[0]}`";

    TerminalHandler.generic_cmd "git clone https://github.com/#{parts[1]} libs/#{parts[0]} 2>&1";
    Dir.cd "libs/#{parts[0]}";
    TerminalHandler.rm ".git*";
    TerminalHandler.generic_cmd "em install";
    TerminalHandler.generic_cmd "em build lib release";
    TerminalHandler.generic_cmd "find . -mindepth 1 -not -path \"./export*\" -not -path \"./libs*\" -exec rm -rf {} + 2>&1";
    Dir.cd "../../";
  end
end
