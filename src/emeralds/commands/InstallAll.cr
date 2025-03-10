class Emeralds::InstallAll < Emeralds::Command
  def message
    "Emeralds - Resolving all dependencies...";
  end

  # Installs all missing development dependencies for the em library
  def block
    -> {
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dependencies;
      install_deps Emfile.instance.dev_dependencies;
    };
  end
end
