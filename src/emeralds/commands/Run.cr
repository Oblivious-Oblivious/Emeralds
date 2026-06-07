abstract class Emeralds::Run < Emeralds::Command
  def message
    "Emeralds - Running executable...";
  end

  abstract def block;
end
