class Emeralds::BuildLibDev < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (dev) mode...";
  end

  def block
    -> {
      Build.new.build_lib Emfile.instance.compile_flags.dev;
    };
  end
end
