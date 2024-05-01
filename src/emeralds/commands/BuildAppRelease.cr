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
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["release_opt"]} #{Emeralds.opt["release_version"]} #{Emeralds.opt["release_flags"]} #{Emeralds.opt["release_warnings"]} -o #{Emeralds.opt["output"]} #{Emeralds.opt["input"]}", display: true;
      move_output_to_export;
    };
  end
end
