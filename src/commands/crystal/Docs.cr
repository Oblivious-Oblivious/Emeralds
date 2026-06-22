class Emeralds::Crystal::Docs < Emeralds::Docs
  def block
    -> {
      Terminal.generic_cmd "crystal docs #{File.join("src", "*.cr")}", display: true;
    };
  end
end
