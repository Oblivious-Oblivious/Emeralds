class Emeralds::BuildAppDebug < Emeralds::Command
  def message
    "Emeralds - Compiling as an app...";
  end

  # Compile libraries into shared libraries and source
  # code as a binary executable in debug mode
  def block
    -> {
      build_app_debug;
    };
  end
end
