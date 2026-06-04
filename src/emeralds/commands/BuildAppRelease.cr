class Emeralds::BuildAppRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (release) mode...";
  end

  def block
    -> {
      build_app Emfile.instance.compile_flags.release;
    };
  end
end
