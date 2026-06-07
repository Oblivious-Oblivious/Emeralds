class Emeralds::Crystal::BuildAppStage < Emeralds::BuildAppStage
  def block
    -> {
      Crystal::Build.new.build_app Emfile.instance.compile_flags.stage;
    };
  end
end
