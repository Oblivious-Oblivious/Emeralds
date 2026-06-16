class Emeralds::C::InstallAll < Emeralds::InstallAll
  def block
    -> {
      Terminal.mkdir "libs";
      install = C::Install.new;
      install.install_deps Emfile.instance.dependencies;
      install.install_deps Emfile.instance.dev_dependencies;
      install.promote_links;
    };
  end
end
