class Emeralds::Lint < Emeralds::Command
  private def ignored?(file)
    lintignore = Emfile.instance.lintignore;
    extensions = lintignore.extensions || [] of String;
    directories = lintignore.directories || [] of String;
    return true if extensions.includes? File.extname(file);

    directories.any? do |directory|
      directory = Path[directory].to_posix.to_s.chomp("/");
      file == directory || file.starts_with? "#{directory}/";
    end
  end

  private def format_file(file)
    output = IO::Memory.new;
    status = Process.run "clang-format", [file], output: output, error: Process::Redirect::Inherit;
    formatted = output.to_s;

    if !status.success?
      puts "#{ARROW} #{file}".colorize(:red);
    elsif formatted == File.read(file)
      puts "#{ARROW} #{file}".colorize(:dark_gray);
    else
      File.write file, formatted;
      puts "#{ARROW} #{file}";
    end
  end

  def message
    "Emeralds - Linting sources...";
  end

  def block
    -> {
      files = Dir
        .glob("**/*.c", "**/*.h")
        .map { |file| Path[file].to_posix.to_s }
        .reject { |file| ignored? file }
        .sort!;

      if files.empty?
        puts "#{ARROW} No source files found".colorize(:red);
      elsif Process.find_executable("clang-format").nil?
        puts "#{ARROW} clang-format not found".colorize(:red);
      else
        files.each { |file| format_file file }
      end
    };
  end
end
