module Emeralds
    COG       = "⚙".colorize(:light_green).mode(:dim).to_s;
    ARROW     = "➔".colorize(:dark_gray).to_s;
    CHECKMARK = "✔".colorize(:light_green).to_s;
    DIAMOND   = "◈";

    PATHS = [
        Path.new("src/**/*.c"),
        Path.new("src/**/*.h"),
        Path.new("spec/**/*.spec.c"),
        Path.new("spec/**/*.spec.h")
    ];
end
