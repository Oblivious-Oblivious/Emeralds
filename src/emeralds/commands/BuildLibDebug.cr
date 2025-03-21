class Emeralds::BuildLibDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  def block
    -> {
      build_lib Emfile.instance.compile_flags.debug;
    };
  end
end
