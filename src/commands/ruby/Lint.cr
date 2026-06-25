class Emeralds::Ruby::Lint < Emeralds::Lint
  def block
    -> {
      files = (Dir.glob("src/**/*.rb") + Dir.glob("spec/**/*.rb")).sort!;
      if files.empty?
        puts "#{ARROW} No source files found".colorize(:red);
      elsif Process.find_executable("rubocop").nil?
        puts "#{ARROW} rubocop not found".colorize(:red);
      else
        Process.run("rubocop", ["-A"] + files,
          output: Process::Redirect::Inherit,
          error: Process::Redirect::Inherit);
      end
    };
  end
end
