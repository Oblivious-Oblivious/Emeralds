class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  def block
    -> {
      if Emfile.instance.name == ""
        puts "Not a valid library (missing `em.json`)".colorize(:red);
      else
        puts "#{ARROW} #{Emfile.instance.name} v#{Emfile.instance.version}";
      end
    };
  end
end
