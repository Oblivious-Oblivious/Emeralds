class Emeralds::Run < Emeralds::Command
  def message
    "Emeralds - Running executable...";
  end

  # Count the number of lines of code
  def block
    -> {
      Terminal.run(Terminal.output_app, display: true);
    };
  end
end
