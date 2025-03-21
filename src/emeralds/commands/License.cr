class Emeralds::License < Emeralds::Command
  def message
    "Emeralds - Downloading license...";
  end

  def block
    -> {
      wget_license;
    };
  end
end
