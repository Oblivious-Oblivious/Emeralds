class Emeralds::BuildAppStage < Emeralds::Command
  def message
    "Emeralds - Compiling as an app in (stage) mode...";
  end

  def block
    -> {
      Build.new.build_app Emfile.instance.compile_flags.stage;
    };
  end
end
