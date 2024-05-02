# Defines constants such as version and CLI logger customizations
module Emeralds
  def self.cog
    "⚙".colorize(:light_green).mode(:dim).to_s;
  end

  def self.arrow
    "➔".colorize(:dark_gray).to_s;
  end

  def self.checkmark
    "✔".colorize(:light_green).to_s;
  end

  def self.diamond
    "◈";
  end

  # Paths of source files (for counting lines) 
  PATHS = [
    Path.new(File.join "src", "**", "*.c"),
    Path.new(File.join "src", "**", "*.h"),
    Path.new(File.join "spec", "**", "*.spec.c"),
    Path.new(File.join "spec", "**", "*.spec.h"),
  ];

  # Dependecy source file paths
  DEPSPATHS = [
    Path.new(File.join "libs", "**", "*.c"),
    Path.new(File.join "libs", "**", "*.h"),
  ];
end
