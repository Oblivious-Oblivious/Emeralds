abstract class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  abstract def block;
end
