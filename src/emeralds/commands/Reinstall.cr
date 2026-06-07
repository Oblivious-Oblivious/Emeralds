abstract class Emeralds::Reinstall < Emeralds::Command
  def message
    "Emeralds - Reinstalling dependencies...";
  end

  abstract def block;
end
