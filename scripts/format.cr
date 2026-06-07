def key(line)
  s = line.strip.gsub(/\s+/, " ").gsub(/ ([(\[])/, "\\1");
  s.ends_with?(";") ? s.rchop.rstrip : s;
end

def restore(src, fmt)
  a = src.lines.map(&.chomp);
  b = fmt.lines.map(&.chomp);
  ka = a.map { |line| key line };
  kb = b.map { |line| key line };
  n = a.size;
  m = b.size;
  dp = Array.new(n + 1) { Array.new(m + 1, 0) };
  (n - 1).downto(0) do |i|
    (m - 1).downto(0) do |j|
      dp[i][j] = ka[i] == kb[j] ?
        dp[i + 1][j + 1] + 1 : {dp[i + 1][j], dp[i][j + 1]}.max;
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

files = ARGV.empty? ? Dir.glob("src/**/*.cr") + Dir.glob("spec/**/*.cr") : ARGV;
exit if files.empty?;

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
