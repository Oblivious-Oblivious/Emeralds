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
        .split("\n")
        .select { |line| line != "" }
        .size;
    end

    [num, loc];
  end

  # Read all dependency source files and count the lines of codes
  #
  # return -> The total number of files and lines of code of libraries
  def self.get_deps_lines_of_code
    self.get_lines_of_code DEPSPATHS;
  end

end
