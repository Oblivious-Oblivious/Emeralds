class Emeralds::BuildAppDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (debug) mode...";
  end

  def block
    -> {
      build_app Emfile.instance.compile_flags.debug;
    };
  end
end
