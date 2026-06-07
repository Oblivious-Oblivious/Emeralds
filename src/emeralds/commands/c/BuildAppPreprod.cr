class Emeralds::C::BuildAppPreprod < Emeralds::BuildAppPreprod
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.preprod;
    };
  end
end
