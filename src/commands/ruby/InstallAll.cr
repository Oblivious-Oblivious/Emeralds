class Emeralds::Ruby::InstallAll < Emeralds::InstallAll
  def block
    -> {
      puts "#{ARROW} Ruby dependencies are handled through `bundler`, use `em install`.".colorize(:yellow);
    };
  end
end
