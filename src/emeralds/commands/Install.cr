abstract class Emeralds::Install < Emeralds::Command
  def message
    "Emeralds - Resolving dependencies...";
  end

  abstract def block;
end
