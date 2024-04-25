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
      cmd = "#{OPT["cc"]} #{OPT["debug_opt"]} #{OPT["debug_version"]} #{OPT["debug_flags"]} #{OPT["debug_warnings"]} #{OPT["unused_warnings"]} -o #{OPT["output"]} $(#{OPT["input"]}) $(#{OPT["inputfiles"]}) $(#{OPT["deps"]})";
      puts cmd;
      `#{cmd}`;
      move_output_to_export;
    };
  end
end
