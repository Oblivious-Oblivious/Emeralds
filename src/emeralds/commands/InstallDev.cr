class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  # Installs all missing development dependencies for the em library
  def block
    -> {
      TerminalHandler.mkdir "libs";
      Emfile.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
