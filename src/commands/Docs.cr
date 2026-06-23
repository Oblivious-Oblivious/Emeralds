abstract class Emeralds::Docs < Emeralds::Command
  def message
    "Emeralds - Generating documentation...";
  end

  abstract def block;
end
