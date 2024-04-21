require "./command";

class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  def block
    -> {
      cmd.run_test_script;
    };
  end
end
