class Emeralds::Crystal::BuildLibRelease < Emeralds::BuildLibRelease
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.release;
    };
  end
end
