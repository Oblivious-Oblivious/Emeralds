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
      cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["debug_opt"]} #{Emeralds::OPT["debug_version"]} #{Emeralds::OPT["debug_flags"]} #{Emeralds::OPT["warnings"]} #{Emeralds::OPT["remove_warnings"]} #{Emeralds::OPT["unused_warnings"]} #{Emeralds::OPT["libs"]} $(#{Emeralds::OPT["inputfiles"]}) 2>&1 | grep -v \"no input files\"";
      puts cmd;
      `#{cmd}`;
      copy_libraries_to_export;
    };
  end
end
