require "./command";

class Emeralds::InstallDev < Emeralds::Command
  def message
    "Emeralds - Resolving development dependencies...";
  end

  # Installs all missing development dependencies for the em library
  def block
    -> {
      unless Dir.exists? "libs"
        Dir.mkdir "libs";
      end

      Emeralds::YamlHelper.get_dev_dependencies.each do |dep|
        Emeralds::CommandProcessor.install_dep dep unless dep == "";
      end
    };
  end
end
