class Emeralds::Loc < Emeralds::Command
  SRC_PATHS = [
    Path.new(File.join "src", "**", "*.c"),
    Path.new(File.join "src", "**", "*.h"),
  ];

  SPEC_PATHS = [
    Path.new(File.join "spec", "**", "*.spec.c"),
    Path.new(File.join "spec", "**", "*.spec.h"),
  ];

  PATHS = SRC_PATHS + SPEC_PATHS;

  private def get_lines_of_code(paths_array = PATHS)
    num = 0;
    loc = 0;

    Dir.glob paths_array do |file|
      num += 1;
      loc += File
        .read(file)
        .gsub(/\/\*.*?\*\//m, "")
        .gsub(/\/\/.*/, "")
        .lines
        .map(&.strip)
        .reject(&.empty?)
        .size;
    end

    [num, loc];
  end

  def message
    "Emeralds - Counting Lines of Code...";
  end

  def block
    -> {
      src_data = get_lines_of_code(SRC_PATHS);
      spec_data = get_lines_of_code(SPEC_PATHS);
      files = src_data[0] + spec_data[0];
      loc = src_data[1] + spec_data[1];
      puts "  #{COG} Files: #{files.to_s.colorize(:white).mode(:bold)}";
      puts "  #{COG} Lines of code: #{loc.to_s.colorize(:white).mode(:bold)}";
      puts "  #{COG} #{(src_data[1].to_f / loc * 100).round.to_i}% src code";
      puts "  #{COG} #{(spec_data[1].to_f / loc * 100).round.to_i}% spec code";
    };
  end
end
