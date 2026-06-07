class Emeralds::C::BuildLibPreprod < Emeralds::BuildLibPreprod
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.preprod;
    }
  end
end
