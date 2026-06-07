class Emeralds::C::BuildLibRelease < Emeralds::BuildLibRelease
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.release;
    }
  end
end
