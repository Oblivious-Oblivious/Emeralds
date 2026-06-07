class Emeralds::Run < Emeralds::Command
  def message
    "Emeralds - Running executable...";
  end

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
