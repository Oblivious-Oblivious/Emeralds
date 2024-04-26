class Emeralds::Run < Emeralds::Command
  def message
    "Running executable...";
  end

  # Count the number of lines of code
  def block
    -> {
      puts TerminalHandler.generic_cmd "./export/#{OPT["output"]}", display: true;
    };
  end
end
