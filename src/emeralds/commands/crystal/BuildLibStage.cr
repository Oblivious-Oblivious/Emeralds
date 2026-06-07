class Emeralds::Crystal::BuildLibStage < Emeralds::BuildLibStage
  def block
    -> {
      Crystal::Build.new.build_lib Emfile.instance.compile_flags.stage;
    };
  end
end
