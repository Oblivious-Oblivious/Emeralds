abstract class Emeralds::Lint < Emeralds::Command
  def message
    "Emeralds - Linting sources...";
  end

  abstract def block;
end
