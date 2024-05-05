class Emeralds::LocAll < Emeralds::Command
  def message
    "Emeralds - Counting all lines of code across source and dependencies...";
  end

  # Count the number of lines of code in source and deps
  def block
    -> {
      src_data = FileHandler.get_lines_of_code;
      deps_data = FileHandler.get_deps_lines_of_code;
      puts "  #{Emeralds.cog} Files: #{(src_data[0]+deps_data[0]).to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds.cog} Lines of code: #{(src_data[1]+deps_data[1]).to_s.colorize(:white).mode(:bold)}";
    };
  end
end
