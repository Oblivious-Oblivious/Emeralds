class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dev_dependencies;
    };
  end
end
