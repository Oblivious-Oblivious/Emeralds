class Emeralds::Run < Emeralds::Command
  def message
    "Running executable...";
  end

  # Count the number of lines of code
  def block
    -> {
      TerminalHandler.run(Emeralds.opt["output"], display: true);
    };
  end
end
