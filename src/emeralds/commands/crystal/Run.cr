class Emeralds::Crystal::Run < Emeralds::Run
  def block
    -> {
      executable = Crystal::Build.new.output_app;
      if File.exists? executable
        Terminal.run(executable, display: true);
      else
        puts "#{ARROW} `#{executable}` not found, build the project first".colorize(:yellow);
      end
    };
  end
end
