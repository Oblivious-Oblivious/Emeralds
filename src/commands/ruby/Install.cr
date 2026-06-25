class Emeralds::Ruby::Install < Emeralds::Install
  def block
    -> {
      Terminal.generic_cmd "bundle install", display: true;
    };
  end
end
