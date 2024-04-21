require "./command";

class Emeralds::BuildRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in release mode
  def block
    -> {
      return if try_override_command;
      Emeralds::CompilerOptionsHelper.application_release;
    };
  end
end
