require "./command";

class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  # Get the em version from the yaml file
  def block
    -> {
      if Emeralds::YamlHelper.get_field("name") == ""
        puts "Not a valid library (missing `em.yml`)";
      else
        puts "#{Emeralds::YamlHelper.get_field "name"} v#{Emeralds::YamlHelper.get_field "version"}";
      end
    };
  end
end
