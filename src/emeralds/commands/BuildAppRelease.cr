class Emeralds::BuildAppRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in release mode
  def block
    -> {
      build_app Emfile.instance.compile_flags.release;
    };
  end
end
