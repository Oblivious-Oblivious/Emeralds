class Emeralds::BuildLibProd < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (prod) mode...";
  end

  def block
    -> {
      Build.new.build_lib Emfile.instance.compile_flags.prod;
    };
  end
end
