abstract class Emeralds::InstallLink < Emeralds::Command
  @link = "";

  def initialize(link = "")
    super "";
    @link = link.strip;
    if @link.empty?
      puts "Invalid name: #{link}.".colorize(:red);
      exit 0;
    end
  end

  def message
    "Emeralds - Installing `#{@link}`...";
  end

  abstract def block;
end
