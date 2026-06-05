class Emeralds::Version < Emeralds::Command
  def message
    "Emeralds - Version";
  end

  def block
    -> {
      version = Emfile.instance.version;
      if Emfile.instance.name == ""
        puts "Not a valid library (missing `em.json`)".colorize(:red);
      elsif version.nil? || version.lstrip.rstrip.empty?
        puts "#{ARROW} `version` field not set in em.json".colorize(:yellow);
      else
        puts "#{ARROW} #{Emfile.instance.name} v#{version.lstrip.rstrip}";
      end
    };
  end
end
