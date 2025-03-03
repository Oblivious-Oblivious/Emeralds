class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  # Get the em version from the yaml file
  def block
    -> {
      if Emfile.instance.name == ""
        puts "Not a valid library (missing `em.json`)".colorize(:red);
      else
        puts "#{Emeralds.arrow} #{Emfile.instance.name} v#{Emfile.instance.version}";
      end
    };
  end
end
