class Emeralds::C::BuildAppRelease < Emeralds::BuildAppRelease
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.release;
    };
  end
end
