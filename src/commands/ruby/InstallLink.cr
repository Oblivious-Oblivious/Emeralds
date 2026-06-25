class Emeralds::Ruby::InstallLink < Emeralds::InstallLink
  def block
    -> {
      Terminal.generic_cmd "gem install #{@link}", display: true;
    };
  end
end
