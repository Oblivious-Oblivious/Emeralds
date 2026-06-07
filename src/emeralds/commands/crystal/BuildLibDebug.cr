class Emeralds::Crystal::BuildLibDebug < Emeralds::BuildLibDebug
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.debug;
    };
  end
end
