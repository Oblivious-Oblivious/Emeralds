class Emeralds::Loc < Emeralds::Command
  def message
    "Counting Lines of Code...";
  end

  # Count the number of lines of code
  def block
    -> {
      data = FileHandler.get_lines_of_code;
      puts "  #{COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
      puts "  #{COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
    };
  end
end
