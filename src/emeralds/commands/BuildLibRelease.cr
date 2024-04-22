class Emeralds::BuildLibRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  # Compile both libraries and source files
  # into shared libraries in release mode
  def block
    -> {
      return if Emeralds::CommandProcessor.try_override_command;
      Emeralds::CompilerOptionsHelper.library_release;
    };
  end
end
