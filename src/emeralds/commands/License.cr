class Emeralds::License < Emeralds::Command
  def message
    "Emeralds - Downloading license...";
  end

  # Get the em version from the yaml file
  def block
    -> {
      wget_license;
    };
  end
end
