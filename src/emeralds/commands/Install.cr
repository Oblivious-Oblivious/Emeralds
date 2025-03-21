class Emeralds::Install < Emeralds::Command
  def message
    "Emeralds - Resolving dependencies...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dependencies;
    };
  end
end
