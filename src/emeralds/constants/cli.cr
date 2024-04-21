# Defines constants such as version and CLI logger customizations
module Emeralds
  # Constants for better displaying of status
  COG       = "⚙".colorize(:light_green).mode(:dim).to_s;
  ARROW     = "➔".colorize(:dark_gray).to_s;
  CHECKMARK = "✔".colorize(:light_green).to_s;
  DIAMOND   = "◈";

  # TODO - Revamp paths

  # Paths of source files (for counting lines) 
  PATHS = [
    Path.new("src/**/*.c"),
    Path.new("src/**/*.h"),
    Path.new("spec/**/*.spec.c"),
    Path.new("spec/**/*.spec.h"),
  ];

  # Dependecy source file paths
  DEPSPATHS = [
    Path.new("libs/**/*.c"),
    Path.new("libs/**/*.h"),
  ];
end
