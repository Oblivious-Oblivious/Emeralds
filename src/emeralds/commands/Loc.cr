class Emeralds::Loc < Emeralds::Command
  def message
    "Counting Lines of Code...";
  end

  # Count the number of lines of code
  def block
    -> {
      data = Emeralds::YamlReader.get_lines_of_code;
      puts "  #{Emeralds::COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds::COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
    };
  end
end
