class Emeralds::BuildAppRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  def block
    -> {
      build_app Emfile.instance.compile_flags.release;
    };
  end
end
