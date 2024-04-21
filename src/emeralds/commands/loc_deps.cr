require "./command";

class Emeralds::LocDeps < Emeralds::Command
  def message
    "Counting Lines of Code for dependencies...";
  end

  def block
    -> {
      data = cmd.count_deps_lines_of_code;
      puts "  #{Emeralds::COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
      puts "  #{Emeralds::COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
    };
  end
end
