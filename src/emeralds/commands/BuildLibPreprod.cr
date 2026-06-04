class Emeralds::BuildLibPreprod < Emeralds::Command
  def message
    "Emeralds - Compiling as a library in (preprod) mode...";
  end

  def block
    -> {
      Build.new.build_lib Emfile.instance.compile_flags.preprod;
    };
  end
end
