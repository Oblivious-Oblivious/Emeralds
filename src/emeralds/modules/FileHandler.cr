module Emeralds::FileHandler
  # Read all source files and count the lines of codes
  #
  # paths_array -> An array of paths for available for search
  # return -> The total number of files and lines of code
  def self.get_lines_of_code(paths_array = PATHS)
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

  # Search for all patterns in start_dir (command emulates linux find start_dir -name pattern)
  #
  # return -> An array of matches
  def self.find(path)
    matches = [] of String;

    Dir.glob(path) do |file|
      matches << file if File.file? file
    end

    matches.uniq! { |path| path.split('/').last };
  end

  # Delete all paths in base_dir except the excluded array
  def self.delete_excluded_paths(base_dir, exclude_patterns)
    base_dir_path = Path[base_dir];
    Dir.glob(base_dir_path.join("**", "{*,.*}")) do |path|
      path = Path[path];
      relative_path = path.relative_to(base_dir_path).to_s.lchop('/');
      next if exclude_patterns.any? do |pattern|
        pattern = pattern.lchop("./");
        pattern == relative_path || relative_path.starts_with?("#{pattern}/");
      end
      FileUtils.rm_rf(path.to_s) unless File.directory?(path.to_s) && path == base_dir_path;
    end
  end
end
