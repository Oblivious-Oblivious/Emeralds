class Emeralds::Help < Emeralds::Command
  def message
    "Emeralds - Help/Usage";
  end

  # Prints the help text block and exits
  def block
    -> {
      usage;
      exit 0;
    };
  end
end
