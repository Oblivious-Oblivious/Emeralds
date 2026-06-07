class Emeralds::Crystal::BuildAppProd < Emeralds::BuildAppProd
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.prod;
    };
  end
end
