class Emeralds::Ruby::Reinstall < Emeralds::Reinstall
  def block
    -> {
      Terminal.rm "lib";
      Terminal.generic_cmd "bundle install", display: true;
    };
  end
end
