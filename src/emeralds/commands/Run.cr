class Emeralds::Run < Emeralds::Command
  def message
    "Emeralds - Running executable...";
  end

  def block
    -> {
      Terminal.run(Terminal.output_app, display: true);
    };
  end
end
