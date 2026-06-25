class Emeralds::Ruby::Test < Emeralds::Test
  def block
    -> {
      Terminal.generic_cmd "bundle exec rspec", display: true;
    };
  end
end
