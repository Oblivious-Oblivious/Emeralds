class Emeralds::C::BuildAppStage < Emeralds::BuildAppStage
  def block
    -> {
      C::Build.new.build_app Emfile.instance.compile_flags.stage;
    };
  end
end
