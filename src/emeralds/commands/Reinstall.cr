class Emeralds::Reinstall < Emeralds::Command
  def message
    "Emeralds - Reinstalling dependencies...";
  end

  def block
    -> {
      Terminal.rm "libs";
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dependencies;
      install_deps Emfile.instance.dev_dependencies;
    };
  end
end
