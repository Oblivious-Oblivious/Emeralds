abstract class Emeralds::Command
  # Tries to execute the override compilation directive if it exists
  #
  # returns -> true if the override was ran else false
  private def try_override_command
    override = YamlReader.get_field "build";
    if override.strip != ""
      TerminalHandler.generic_cmd override, display: true;
      true;
    else
      false;
    end
  end
end
