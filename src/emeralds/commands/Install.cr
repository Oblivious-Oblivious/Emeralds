class Emeralds::Install < Emeralds::Command
  def message
    "Emeralds - Resolving dependencies...";
  end

  # Installs all missing dependencies for the em library
  def block
    -> {
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dependencies;
    };
  end
end
