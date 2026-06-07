class Emeralds::Crystal::InstallAll < Emeralds::InstallAll
  def block
    -> {
      puts "#{ARROW} Crystal dependencies are handled through `shards`, use `em install`.".colorize(:yellow);
    };
  end
end
