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
end
