require "./command";

class Emeralds::Install < Emeralds::Command
  def message
    "Emeralds - Resolving dependencies...";
  end

  # Installs all missing dependencies for the em library
  def block
    -> {
      unless Dir.exists? "libs"
        Dir.mkdir "libs";
      end

      Emeralds::YamlHelper.get_dependencies.each do |dep|
        Emeralds::CommandProcessor.install_dep dep unless dep == "";
      end
    };
  end
end
