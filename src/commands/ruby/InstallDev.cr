class Emeralds::Ruby::InstallDev < Emeralds::InstallDev
  def block
    -> {
      puts "#{ARROW} Ruby dependencies are handled through `bundler`, use `em install`.".colorize(:yellow);
    };
  end
end
