class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  def block
    -> {
      Terminal.rm Terminal.output_test, display: true;
      Terminal.rm "export", display: true;
      Terminal.rm "*.dSYM";
      Terminal.rm "spec/*.dSYM";
      Terminal.rm "export/*.dSYM";
    };
  end
end
