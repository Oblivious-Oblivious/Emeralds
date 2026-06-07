class Emeralds::Crystal::Install < Emeralds::Install
  def block
    -> {
      Terminal.generic_cmd "shards install", display: true;
    };
  end
end
