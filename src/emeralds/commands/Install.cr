class Emeralds::Install < Emeralds::Command
  def message
    "Emeralds - Resolving dependencies...";
  end

  # Installs all missing dependencies for the em library
  def block
    -> {
      TerminalHandler.mkdir "libs";

      YamlReader.get_dependencies.each do |dep|
        install_dep dep unless dep == "";
      end
    };
  end
end
