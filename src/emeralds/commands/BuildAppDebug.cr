class Emeralds::BuildAppDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in debug mode
  def block
    -> {
      return if try_override_command;

      TerminalHandler.rm "export";
      TerminalHandler.mkdir "export";

      cc = Emfile.instance.compile_flags.cc;
      opt = Emfile.instance.compile_flags.debug.opt;
      version = Emfile.instance.compile_flags.debug.version;
      flags = Emfile.instance.compile_flags.debug.flags;
      warnings = Emfile.instance.compile_flags.debug.warnings;
      libs = Emfile.instance.compile_flags.debug.libs;
      input = Emeralds.opt["app"]["input"];
      output = Emeralds.opt["app"]["output"];
      TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} #{libs} -o #{output} #{input} 2> /dev/null", display: true;
    };
  end
end
