class Emeralds::InstallAll < Emeralds::Command
  def message
    "Emeralds - Resolving all dependencies...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      install = Install.new;
      install.install_deps Emfile.instance.dependencies;
      install.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
