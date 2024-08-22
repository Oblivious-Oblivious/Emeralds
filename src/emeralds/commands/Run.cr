class Emeralds::Run < Emeralds::Command
  def message
    "Emeralds - Running executable...";
  end

  # Count the number of lines of code
  def block
    -> {
      TerminalHandler.run(Emeralds.output_app, display: true);
    };
  end
end
