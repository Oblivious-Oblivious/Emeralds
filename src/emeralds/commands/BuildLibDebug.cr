class Emeralds::BuildLibDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  # Compile both libraries and source files
  # into shared libraries in debug mode
  def block
    -> {
      return if try_override_command;

      TerminalHandler.rm "export";
      TerminalHandler.mkdir "export";
      TerminalHandler.cp (File.join "src", "*"), "export";
      TerminalHandler.rm (File.join "export", "*.c");
      TerminalHandler.rm (File.join "export", "**", "*.c");
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["debug_opt"]} #{Emeralds.opt["debug_version"]} #{Emeralds.opt["debug_flags"]} #{Emeralds.opt["debug_warnings"]} #{Emeralds.opt["unused_warnings"]} #{Emeralds.opt["libs"]} #{Emeralds.opt["inputfiles"]} 2> /dev/null", display: true;
      TerminalHandler.mv "#{FileHandler.find_with_pattern(File.join(".", "**", "*.o")).join ' '}", "export";
    };
  end
end
