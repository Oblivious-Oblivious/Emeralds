class Emeralds::C::BuildAppProd < Emeralds::BuildAppProd
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.prod;
    };
  end
end
