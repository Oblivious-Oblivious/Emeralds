abstract class Emeralds::InstallAll < Emeralds::Command
  def message
    "Emeralds - Resolving all dependencies...";
  end

  abstract def block;
end
