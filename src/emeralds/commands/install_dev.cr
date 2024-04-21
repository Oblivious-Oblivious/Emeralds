require "./command";

class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  def block
    -> {
      cmd.install_dev_dependencies;
    };
  end
end
