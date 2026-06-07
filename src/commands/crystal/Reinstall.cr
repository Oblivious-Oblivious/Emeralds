class Emeralds::Crystal::Reinstall < Emeralds::Reinstall
  def block
    -> {
      Terminal.rm "lib";
      Terminal.generic_cmd "shards install", display: true;
    };
  end
end
