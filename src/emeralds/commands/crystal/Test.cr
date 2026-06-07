class Emeralds::Crystal::Test < Emeralds::Test
  def block
    -> {
      Terminal.generic_cmd "crystal spec #{File.join("spec", "#{Emfile.instance.name}.spec.cr")}", display: true;
    };
  end
end
