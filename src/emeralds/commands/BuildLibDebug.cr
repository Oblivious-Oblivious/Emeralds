class Emeralds::BuildLibDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (debug) mode...";
  end

  def block
    -> {
      Build.new.build_lib Emfile.instance.compile_flags.debug;
    };
  end
end
