class Emeralds::BuildAppRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in release mode
  def block
    -> {
      return if try_override_command;

      make_export;
      TerminalHandler.generic_cmd "#{OPT["cc"]} #{OPT["release_opt"]} #{OPT["release_version"]} #{OPT["release_flags"]} #{OPT["release_warnings"]} -o #{OPT["output"]} #{OPT["input"]}", display: true;
      move_output_to_export;
    };
  end
end
