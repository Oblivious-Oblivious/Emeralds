class Emeralds::C::BuildLibProd < Emeralds::BuildLibProd
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.prod;
    }
  end
end
