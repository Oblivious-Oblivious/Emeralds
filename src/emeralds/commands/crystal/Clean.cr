class Emeralds::Crystal::Clean < Emeralds::Clean
  def block
    -> {
      Terminal.rm "bin/#{Emfile.instance.name}", display: true;
      Terminal.rm "bin/*.dwarf", display: true;
      Terminal.rm "*.dwarf", display: true;
    };
  end
end
