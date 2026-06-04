class Emeralds::InstallAll < Emeralds::Command
  def message
    "Emeralds - Resolving all dependencies...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      build = Build.new;
      build.install_deps Emfile.instance.dependencies;
      build.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
