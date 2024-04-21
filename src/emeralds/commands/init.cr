require "./command";

class Emeralds::Init < Emeralds::Command
  def message
    "Emeralds - Initializing a new project";
  end

  def block
    -> {
      cmd.usage if ARGV.size < 2;
      cmd.initialize_em_library ARGV[1];
    };
  end
end
