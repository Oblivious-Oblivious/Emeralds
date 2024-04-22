class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      Emeralds::CompilerOptionsHelper.test_script;
    };
  end
end
