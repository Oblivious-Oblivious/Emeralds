class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      Build.new.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
