class Emeralds::Crystal::InstallDev < Emeralds::InstallDev
  def block
    -> {
      puts "#{ARROW} Crystal dependencies are handled through `shards`, use `em install`.".colorize(:yellow);
    };
  end
end
