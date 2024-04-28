class Emeralds::LocDeps < Emeralds::Command
  def message
    "Counting Lines of Code for dependencies...";
  end

  # Count the number of lines of code in dependencies
  def block
    -> {
      puts "  #{Emeralds::COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds::COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
      data = FileHandler.get_deps_lines_of_code;
    };
  end
end
