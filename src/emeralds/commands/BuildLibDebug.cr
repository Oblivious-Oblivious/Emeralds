class Emeralds::BuildLibDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  # Compile both libraries and source files
  # into shared libraries in debug mode
  def block
    -> {
      return if try_override_command;

      make_export;
      copy_headers;
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["debug_opt"]} #{Emeralds.opt["debug_version"]} #{Emeralds.opt["debug_flags"]} #{Emeralds.opt["debug_warnings"]} #{Emeralds.opt["unused_warnings"]} #{Emeralds.opt["libs"]} #{Emeralds.opt["inputfiles"]} 2> /dev/null", display: true;
      move_libraries_to_export;
    };
  end
end
