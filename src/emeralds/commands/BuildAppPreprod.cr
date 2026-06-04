class Emeralds::BuildAppPreprod < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (preprod) mode...";
  end

  def block
    -> {
      build_app Emfile.instance.compile_flags.preprod;
    };
  end
end
