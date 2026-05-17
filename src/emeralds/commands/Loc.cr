class Emeralds::Loc < Emeralds::Command
  SRC_PATHS = [
    Path.new(File.join "src", "**", "*"),
  ];

  SPEC_PATHS = [
    Path.new(File.join "spec", "**", "*"),
  ];

  PATHS = SRC_PATHS + SPEC_PATHS;

  private def language_for(file)
    extension = File.extname(file);
    EXTENSIONS[extension]? || EXTENSIONS[extension.downcase]?;
  end

  private def get_lines_of_code(paths_array = PATHS)
    num = 0;
    loc = 0;
    languages = Hash(String, Int32).new(0);

    Dir.glob paths_array do |file|
      next unless File.file? file;

      language = language_for file;
      next if language.nil?

      file_loc = File
        .read(file)
        .gsub(/\/\*.*?\*\//m, "")
        .gsub(/\/\/.*/, "")
        .lines
        .map(&.strip)
        .reject(&.empty?)
        .size;

      num += 1;
      loc += file_loc;
      languages[language] += file_loc;
    end

    {num, loc, languages};
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
      return if loc == 0;

      puts "  #{COG} #{(src_data[1].to_f / loc * 100).round.to_i}% src code";
      puts "  #{COG} #{(spec_data[1].to_f / loc * 100).round.to_i}% spec code";

      src_data[2].merge(spec_data[2]) { |_, src_loc, spec_loc|
        src_loc + spec_loc;
      }.to_a.sort_by { |lang, lines|
        {-lines, lang};
      }.each { |lang, lines|
        puts "  #{COG} #{lang}: #{lines.colorize(:white).mode(:bold)}";
      };
    };
  end
end
