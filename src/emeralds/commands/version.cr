require "./command";

class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  def block
    -> {
      puts cmd.get_em_version;
    };
  end
end
