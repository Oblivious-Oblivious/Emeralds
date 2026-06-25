class Emeralds::Ruby::Uninstall < Emeralds::Uninstall
  def block
    -> {
      puts "#{ARROW} Ruby dependencies are handled through `bundler`, edit the Gemfile and run `em install`.".colorize(:yellow);
    };
  end
end
