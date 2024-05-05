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

      cc = Emfile.instance.compile_flags.cc;
      opt = Emfile.instance.compile_flags.debug.opt;
      version = Emfile.instance.compile_flags.debug.version;
      flags = Emfile.instance.compile_flags.debug.flags;
      warnings = Emfile.instance.compile_flags.debug.warnings;
      libs = Emfile.instance.compile_flags.debug.libs;
      input = Emeralds.opt["lib"]["input"];
      TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} #{libs} -c #{input} 2> /dev/null", display: true;
      TerminalHandler.mv "#{FileHandler.find_with_pattern(File.join(".", "**", "*.o")).join ' '}", "export";
    };
  end
end
