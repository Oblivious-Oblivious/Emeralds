require "open3";

def key(line)
  s = line.strip.gsub(/\s+/, " ").gsub(/ ([(\[])/, '\1');
  s.end_with?(";") ? s[0..-2].rstrip : s;
end

def restore(src, fmt)
  a = src.lines.map(&:chomp);
  b = fmt.lines.map(&:chomp);
  ka = a.map { |l| key l };
  kb = b.map { |l| key l };
  n = a.size;
  m = b.size;
  dp = Array.new(n + 1) { Array.new(m + 1, 0) };
  (n - 1).downto(0) do |i|
    (m - 1).downto(0) do |j|
      dp[i][j] = ka[i] == kb[j] ?
        dp[i + 1][j + 1] + 1 : [dp[i + 1][j], dp[i][j + 1]].max;
    end;
  end;
  out = b.dup;
  i = j = 0;
  while i < n && j < m
    if ka[i] == kb[j]
      if a[i].rstrip.end_with?(";") && !out[j].rstrip.end_with?(";")
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
  fmt.end_with?("\n") ? r + "\n" : r;
end

files = ARGV.empty? ? Dir["src/**/*.cr"] + Dir["spec/**/*.cr"] : ARGV;
exit if files.empty?;

orig = files.each_with_object({}) { |p, h| h[p] = File.read(p) };
err = nil;
2.times do
  _out, e, st = Open3.capture3("crystal", "tool", "format", *files);
  err = st.success? ? nil : e.strip;
end;
warn err if err;

files.each do |path|
  fmt = File.read(path);
  result = restore(orig[path], fmt);
  File.write(path, result) if result != fmt;
  color = result == orig[path] ? "\e[90m" : "\e[37m";
  puts "#{color}#{path}\e[0m";
end
