class Emeralds::Crystal::Lint < Emeralds::Lint
  private def key(line : String) : String
    s = line.strip.gsub(/\s+/, " ").gsub(/ ([(\[])/, "\\1");
    s.ends_with?(";") ? s.rchop.rstrip : s;
  end

  private def restore(src : String, fmt : String) : String
    a = src.lines.map(&.chomp);
    b = fmt.lines.map(&.chomp);
    ka = a.map { |line| key line };
    kb = b.map { |line| key line };
    n = a.size;
    m = b.size;
    dp = Array.new(n + 1) { Array.new(m + 1, 0) };
    (n - 1).downto(0) do |i|
      (m - 1).downto(0) do |j|
        dp[i][j] = ka[i] == kb[j] ? dp[i + 1][j + 1] + 1 : {dp[i + 1][j], dp[i][j + 1]}.max;
      end;
    end;
    out = b.dup;
    i = j = 0;
    while i < n && j < m
      if ka[i] == kb[j]
        if a[i].rstrip.ends_with?(";") && !out[j].rstrip.ends_with?(";")
          out[j] = out[j].rstrip + ";";
        end;
        i += 1;
        j += 1;
      elsif dp[i + 1][j] >= dp[i][j + 1]
        i += 1;
      else
        j += 1;
      end;
    end;
    r = out.join("\n");
    fmt.ends_with?("\n") ? r + "\n" : r;
  end

  private def format_files(files : Array(String))
    orig = files.each_with_object({} of String => String) { |path, map|
      map[path] = File.read(path);
    };
    err : String? = nil;
    2.times do
      output = IO::Memory.new;
      errors = IO::Memory.new;
      status = Process.run("crystal", ["tool", "format"] + files,
        output: output, error: errors);
      err = status.success? ? nil : errors.to_s.strip;
    end;
    STDERR.puts err if err;

    files.each do |path|
      fmt = File.read(path);
      result = restore(orig[path], fmt);
      File.write(path, result) if result != fmt;
      color = result == orig[path] ? "\e[90m" : "\e[37m";
      puts "#{color}#{path}\e[0m";
    end
  end

  private def run_ameba
    output = IO::Memory.new;
    error = IO::Memory.new;
    status = Process.run("./bin/ameba", output: output, error: error);
    puts output.to_s;
    STDERR.puts error.to_s unless error.to_s.empty?;
    status;
  end

  def block
    -> {
      unless File.exists? "bin/ameba"
        puts "#{ARROW} ameba not found. Run `shards build ameba` first.".colorize(:yellow);
        exit 0;
      end

      files = Dir.glob("src/**/*.cr") + Dir.glob("spec/**/*.cr");
      unless files.empty?
        format_files files;
      end

      run_ameba;
    };
  end
end
