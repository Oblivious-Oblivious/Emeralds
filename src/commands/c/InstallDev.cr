class Emeralds::C::InstallDev < Emeralds::InstallDev
  def block
    -> {
      Terminal.mkdir "libs";
      C::Install.new.install_deps Emfile.instance.dev_dependencies;
    };
  end
end
