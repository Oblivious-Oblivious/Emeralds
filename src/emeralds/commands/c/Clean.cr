class Emeralds::C::Clean < Emeralds::Clean
  def block
    -> {
      Terminal.rm C::Test.new.output_test, display: true;
      Terminal.rm "export", display: true;
      Terminal.rm "*.dSYM";
      Terminal.rm "spec/*.dSYM";
      Terminal.rm "export/*.dSYM";
    };
  end
end
