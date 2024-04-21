require "./command";

class Emeralds::BuildLibraryRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as a library...";
  end

  def block
    -> {
      cmd.compile_as_library "release";
    };
  end
end
