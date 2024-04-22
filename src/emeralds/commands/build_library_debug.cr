class Emeralds::BuildLibraryDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  # Compile both libraries and source files
  # into shared libraries in debug mode
  def block
    -> {
      return if Emeralds::CommandProcessor.try_override_command;
      Emeralds::CompilerOptionsHelper.library_debug;
    };
  end
end
