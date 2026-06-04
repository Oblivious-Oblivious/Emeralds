class Emeralds::BuildLibStage < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (stage) mode...";
  end

  def block
    -> {
      build_lib Emfile.instance.compile_flags.stage;
    };
  end
end
