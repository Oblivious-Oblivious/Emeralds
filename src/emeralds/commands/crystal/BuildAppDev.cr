class Emeralds::Crystal::BuildAppDev < Emeralds::BuildAppDev
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.dev;
    };
  end
end
