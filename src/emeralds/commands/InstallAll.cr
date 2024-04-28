class Emeralds::InstallAll < Emeralds::Command
  def message
    "Emeralds - Resolving all dependencies...";
  end

  # Installs all missing development dependencies for the em library
  def block
    -> {
      TerminalHandler.mkdir "libs";

      YamlReader.get_dependencies.each do |dep|
        install_dep dep unless dep == "";
      end

      YamlReader.get_dev_dependencies.each do |dep|
        install_dep dep unless dep == "";
      end
    };
  end
end
