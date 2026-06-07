class Emeralds::Crystal::BuildAppPreprod < Emeralds::BuildAppPreprod
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.preprod;
    };
  end
end
