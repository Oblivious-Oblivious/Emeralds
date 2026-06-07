abstract class Emeralds::Uninstall < Emeralds::Command
  def initialize(name = "", @silent = false)
    super name, @silent;
    if @name.empty?
      puts "Invalid name: #{name}.".colorize(:red);
      exit 0;
    end
  end

  def message
    "Emeralds - Uninstalling dependency...";
  end

  abstract def block;
end
