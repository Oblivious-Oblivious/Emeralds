class Emeralds::Loc < Emeralds::Command
  private def language_for(file)
    extension = File.extname(file);
    EXTENSIONS[extension]? || EXTENSIONS[extension.downcase]?;
  end

  private def spec_file?(file)
    file.to_s.starts_with? File.join("spec", "");
  end

  private def get_lines_of_code
    num = 0;
    loc = 0;
    spec_loc = 0;
    languages = Hash(String, Int32).new(0);

    paths = Path.new(File.join "**", "*");
    Dir.glob paths do |file|
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
      spec_loc += file_loc if spec_file? file;
      languages[language] += file_loc;
    end

    {num, loc, loc - spec_loc, spec_loc, languages};
  end

  def message
    "Emeralds - Counting Lines of Code...";
  end

  def block
    -> {
      files, loc, src_loc, spec_loc, languages = get_lines_of_code;

      puts "  #{COG} Files: #{files.to_s.colorize(:white).mode(:bold)}";
      puts "  #{COG} Lines of code: #{loc.to_s.colorize(:white).mode(:bold)}";
      return if loc == 0;

      if src_loc.to_f / loc * 100 && spec_loc.to_f / loc * 100 > 0
        puts "  #{COG} #{(src_loc.to_f / loc * 100).round.to_i}% src code";
        puts "  #{COG} #{(spec_loc.to_f / loc * 100).round.to_i}% spec code";
      end

      languages.to_a.sort_by { |lang, lines|
        {-lines, lang};
      }.each { |lang, lines|
        puts "  #{COG} #{lang}: #{lines.colorize(:white).mode(:bold)}";
      };
    };
  end
end
