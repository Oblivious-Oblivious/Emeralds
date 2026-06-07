class Emeralds::Loc < Emeralds::Command
  private def language_for(file)
    extension = File.extname(file);
    EXTENSIONS[extension]? || EXTENSIONS[extension.downcase]?;
  end

  private def spec_file?(file)
    file.to_s.starts_with? File.join("spec", "");
  end

  private def ignored_file?(file)
    path = file.to_s;
    locignore = Emfile.instance.locignore;
    extension = File.extname(path);
    extensions = locignore.extensions || [] of String;
    directories = locignore.directories || [] of String;
    return true if extensions.includes? extension;
    return true if ignored_directory? path, ".git";

    directories.any? { |directory| ignored_directory? path, directory };
  end

  private def ignored_directory?(path, directory)
    directory = directory.chomp("/");
    path == directory || path.starts_with? File.join(directory, "");
  end

  private def count_file(file)
    File
      .read(file)
      .gsub(/\/\*.*?\*\//m, "")
      .gsub(/\/\/.*/, "")
      .lines
      .map(&.strip)
      .reject(&.empty?).size;
  end

  private def get_lines_of_code
    total = [0, 0];
    src_code = 0;
    spec_code = 0;
    languages = Hash(String, Array(Int32)).new { |hash, key|
      hash[key] = [0, 0];
    };

    paths = [
      Path.new(File.join "**", "*"),
      Path.new(".*"),
      Path.new(File.join ".*", "**", "*"),
    ];
    Dir.glob paths do |file|
      next if ignored_file? file;
      next unless File.file? file;

      language = language_for file;
      next if language.nil?;

      code = count_file(file);
      data = languages[language];

      data[0] += 1;
      data[1] += code;

      total[0] += 1;
      total[1] += code;

      if spec_file? file
        spec_code += code;
      else
        src_code += code;
      end
    end

    {total, src_code, spec_code, languages};
  end

  private def table_row(language, data)
    files = data[0].to_s.rjust(9).colorize(:white).mode(:bold);
    code = data[1].to_s.rjust(10).colorize(:white).mode(:bold);
    " #{COG} %-32s %s %s" % [language, files, code];
  end

  private def sum_row(data)
    table_row "SUM:", data;
  end

  private def table_header
    "%-35s %9s %10s" % ["Language", "files", "code"];
  end

  private def separator
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  def message
    "Emeralds - Counting Lines of Code...";
  end

  def block
    -> {
      total, src_code, spec_code, languages = get_lines_of_code;

      puts table_header;
      puts separator;

      languages.to_a.sort_by { |lang, data|
        {-data[1], lang};
      }.each { |lang, data|
        puts table_row(lang, data);
      };

      puts separator;
      puts sum_row(total);
      return if total[1] == 0;

      if src_code.to_f / total[1] * 100 && spec_code.to_f / total[1] * 100 > 0
        puts separator;
        puts " #{COG} #{(src_code.to_f / total[1] * 100).round.to_i}% src code";
        puts " #{COG} #{(spec_code.to_f / total[1] * 100).round.to_i}% spec code";
      end
    };
  end
end
