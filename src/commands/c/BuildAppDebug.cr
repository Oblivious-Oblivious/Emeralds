class Emeralds::C::BuildAppDebug < Emeralds::BuildAppDebug
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.debug;
    };
  end
end
