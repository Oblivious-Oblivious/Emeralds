class Emeralds::Crystal::BuildLibDev < Emeralds::BuildLibDev
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.dev;
    };
  end
end
