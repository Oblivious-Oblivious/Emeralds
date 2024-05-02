class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  # Get the em version from the yaml file
  def block
    -> {
      if YamlReader.get_field("name") == ""
        puts "Not a valid library (missing `em.yml`)".colorize(:light_red);
      else
        puts "#{Emeralds.arrow} #{YamlReader.get_field "name"} v#{YamlReader.get_field "version"}";
      end
    };
  end
end
