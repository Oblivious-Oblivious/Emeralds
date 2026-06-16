class Emeralds::C::InstallDev < Emeralds::InstallDev
  def block
    -> {
      Terminal.mkdir "libs";
      install = C::Install.new;
      install.install_deps Emfile.instance.dev_dependencies;
      install.promote_links;
    };
  end
end
