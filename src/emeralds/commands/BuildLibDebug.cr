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
      TerminalHandler.generic_cmd "#{OPT["cc"]} #{OPT["debug_opt"]} #{OPT["debug_version"]} #{OPT["debug_flags"]} #{OPT["debug_warnings"]} #{OPT["unused_warnings"]} #{OPT["libs"]} #{OPT["inputfiles"]}", display: true;
      copy_libraries_to_export;
    };
  end
end
