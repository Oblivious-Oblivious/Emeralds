class Emeralds::Loc < Emeralds::Command
  def message
    "Counting Lines of Code...";
  end

  # Count the number of lines of code
  def block
    -> {
      src_data = FileHandler.get_lines_of_code(SRC_PATHS);
      spec_data = FileHandler.get_lines_of_code(SPEC_PATHS);
      files = src_data[0] + spec_data[0];
      loc = src_data[1] + spec_data[1];
      puts "  #{Emeralds.cog} Files: #{files.to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds.cog} Lines of code: #{loc.to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds.cog} #{(src_data[1].to_f / loc * 100).round.to_i}% src code";
      puts "  #{Emeralds.cog} #{(spec_data[1].to_f / loc * 100).round.to_i}% spec code";
    };
  end
end
