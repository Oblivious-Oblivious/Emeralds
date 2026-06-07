class Emeralds::Crystal::BuildAppDebug < Emeralds::BuildAppDebug
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.debug;
    };
  end
end
