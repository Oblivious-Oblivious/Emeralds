class Emeralds::BuildAppProd < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (prod) mode...";
  end

  def block
    -> {
      Build.new.build_app Emfile.instance.compile_flags.prod;
    };
  end
end
