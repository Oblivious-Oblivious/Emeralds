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
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["debug_opt"]} #{Emeralds.opt["debug_version"]} #{Emeralds.opt["debug_flags"]} #{Emeralds.opt["debug_warnings"]} #{Emeralds.opt["unused_warnings"]} -o #{Emeralds.opt["output"]} #{Emeralds.opt["input"]}", display: true;
      move_output_to_export;
    };
  end
end
