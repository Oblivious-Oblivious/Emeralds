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
      cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["release_warnings"]} -o #{Emeralds::OPT["output"]} $(#{Emeralds::OPT["input"]}) $(#{Emeralds::OPT["inputfiles"]}) $(#{Emeralds::OPT["deps"]})";
      puts cmd;
      `#{cmd}`;
      move_output_to_export;
    };
  end
end
