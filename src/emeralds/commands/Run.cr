class Emeralds::Run < Emeralds::Command
  def message
    "Running executable...";
  end

  # Count the number of lines of code
  def block
    -> {
      puts `./export/#{OPT["output"]}`;
    };
  end
end
