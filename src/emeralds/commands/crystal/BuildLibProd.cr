class Emeralds::Crystal::BuildLibProd < Emeralds::BuildLibProd
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.prod;
    };
  end
end
