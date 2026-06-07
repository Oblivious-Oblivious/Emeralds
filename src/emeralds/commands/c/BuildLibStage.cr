class Emeralds::C::BuildLibStage < Emeralds::BuildLibStage
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.stage;
    }
  end
end
