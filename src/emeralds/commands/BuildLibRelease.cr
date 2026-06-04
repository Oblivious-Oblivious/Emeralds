class Emeralds::BuildLibRelease < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (release) mode...";
  end

  def block
    -> {
      Build.new.build_lib Emfile.instance.compile_flags.release;
    };
  end
end
