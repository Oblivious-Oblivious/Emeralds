class Emeralds::Ruby::Clean < Emeralds::Clean
  def block
    -> {
      Terminal.rm ".yardoc", display: true;
      Terminal.rm "doc", display: true;
    };
  end
end
