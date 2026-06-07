class Emeralds::Crystal::BuildAppRelease < Emeralds::BuildAppRelease
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.release;
    };
  end
end
