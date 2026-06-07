class Emeralds::C::BuildAppDev < Emeralds::BuildAppDev
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.dev;
    };
  end
end
