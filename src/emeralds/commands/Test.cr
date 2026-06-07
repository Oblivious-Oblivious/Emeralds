abstract class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  abstract def block;
end
