class Emeralds::C::Run < Emeralds::Run
  def block
    -> {
      executable = C::Build.new.output_app;
      if File.exists? executable
        Terminal.run(executable, display: true);
      else
        puts "#{ARROW} `#{executable}` not found, build the project first".colorize(:yellow);
      end
    };
  end
end
