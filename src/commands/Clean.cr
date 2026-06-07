abstract class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  abstract def block;
end
