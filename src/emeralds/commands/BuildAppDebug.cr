class Emeralds::BuildAppDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in debug mode
  def block
    -> {
      return if try_override_command;

      make_export;
      cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["debug_opt"]} #{Emeralds::OPT["debug_version"]} #{Emeralds::OPT["debug_flags"]} #{Emeralds::OPT["debug_warnings"]} #{Emeralds::OPT["unused_warnings"]} -o #{Emeralds::OPT["output"]} $(#{Emeralds::OPT["input"]}) $(#{Emeralds::OPT["inputfiles"]}) $(#{Emeralds::OPT["deps"]}) 2>&1 | grep -v \"no input files\"";
      puts cmd;
      `#{cmd}`;
      move_output_to_export;
    };
  end
end
