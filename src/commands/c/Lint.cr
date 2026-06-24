class Emeralds::C::Lint < Emeralds::Lint
  private def ignored?(file)
    lintignore = Emfile.instance.lintignore;
    extensions = lintignore.extensions || [] of String;
    directories = lintignore.directories || [] of String;
    return true if extensions.includes? File.extname(file);

    directories.any? do |directory|
      directory = directory.posix_path.chomp("/");
      file == directory || file.starts_with? "#{directory}/";
    end
  end

  private def format(files)
    files.each do |file|
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
  end

  private def deps_include_args
    paths = [] of String;

    Dir.glob(File.join("libs", "*", "export").posix_path) do |path|
      paths << path if File.directory? path;
    end
    Dir.glob(File.join("libs", "*", "export", "**").posix_path) do |path|
      paths << path if File.directory? path;
    end

    paths.uniq.map { |path| "-I#{path}" };
  end

  private def reject_libs_findings(findings)
    libs = "#{File.expand_path("libs").posix_path}/";
    keep = true;
    String.build do |io|
      findings.each_line(chomp: false) do |line|
        if match = line.match(/^(.+?):\d+:\d+:\s+(?:warning|error):/)
          path = File.expand_path(match[1]).posix_path;
          keep = !path.starts_with?(libs);
        end
        io << line if keep;
      end
    end
  end

  private def analyze(files)
    puts "#{ARROW} Running static analysis...";
    args = Emfile.instance.compile_flags.debug[1..] + deps_include_args;
    findings = IO::Memory.new;

    files.each do |file|
      Process.run("clang-tidy", [
        file,
        "--quiet",
        "--",
        "-x", "c",
      ] + args, output: findings, error: findings);
    end

    output = reject_libs_findings findings.to_s;
    if output_path = Options.output.presence
      File.write(output_path, output);
      puts "#{ARROW} Analysis findings written to #{output_path}";
    else
      print output;
    end
  end

  private def execute_tool(tool, file_globs, &)
    files = Dir
      .glob(file_globs)
      .map(&.posix_path)
      .reject { |file| ignored? file }
      .sort!;

    if files.empty?
      puts "#{ARROW} No source files found".colorize(:red);
    elsif Process.find_executable(tool).nil?
      puts "#{ARROW} #{tool} not found".colorize(:red);
    else
      yield files;
    end
  end

  def block
    -> {
      execute_tool("clang-format", [
        File.join("**", "*.c"),
        File.join("**", "*.h"),
      ]) { |files| format files };

      puts separator;

      execute_tool("clang-tidy", [
        File.join("src", "**", "*.c"),
        File.join("src", "**", "*.h"),
      ]) { |files| analyze files };
    };
  end
end
