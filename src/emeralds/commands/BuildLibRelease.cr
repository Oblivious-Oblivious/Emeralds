class Emeralds::BuildLibRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  # Compile both libraries and source files
  # into shared libraries in release mode
  def block
    -> {
      build_lib_release;
    };
  end
end
