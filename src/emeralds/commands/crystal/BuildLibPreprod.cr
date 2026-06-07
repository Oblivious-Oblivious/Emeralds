class Emeralds::Crystal::BuildLibPreprod < Emeralds::BuildLibPreprod
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.preprod;
    };
  end
end
