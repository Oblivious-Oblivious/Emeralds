class Emeralds::BuildAppDev < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (dev) mode...";
  end

  def block
    -> {
      build_app Emfile.instance.compile_flags.dev;
    };
  end
end
