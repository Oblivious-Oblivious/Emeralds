class Emeralds::LocDeps < Emeralds::Command
  def message
    "Emeralds - Counting Lines of Code for dependencies...";
  end

  # Count the number of lines of code in dependencies
  def block
    -> {
      data = FileHandler.get_deps_lines_of_code;
      puts "  #{Emeralds.cog} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds.cog} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
    };
  end
end
