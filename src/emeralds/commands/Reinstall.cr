class Emeralds::Reinstall < Emeralds::Command
  def message
    "Emeralds - Reinstalling dependencies...";
  end

  def block
    -> {
      Terminal.rm "libs";
      Terminal.mkdir "libs";
      install = Install.new;
      install.install_deps Emfile.instance.dependencies;
      install.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
