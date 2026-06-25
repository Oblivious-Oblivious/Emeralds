class Emeralds::Ruby::Run < Emeralds::Run
  def block
    -> {
      name = Emfile.instance.name;
      src_main = File.join "src", "#{name}.rb";
      if File.exists? src_main
        Terminal.generic_cmd "bundle exec ruby #{src_main}", display: true;
      else
        puts "#{ARROW} `#{src_main}` not found, create it first".colorize(:yellow);
      end
    };
  end
end
