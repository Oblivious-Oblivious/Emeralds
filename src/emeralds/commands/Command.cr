# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
  @name = "";
  @func_name = "";
  @silent = false;

  FORBIDDEN_NAME_CHARS   = /[<>:"\\|?*\x00-\x1F]/;
  DOT_ONLY_NAME          = /\A\.+\z/;
  WINDOWS_RESERVED_NAMES = /^(con|prn|aux|nul|com[1-9]|lpt[1-9]|com[0-9]+|lpt[0-9]+)$/i;

  def initialize(
    name = "",
    @silent = false,
  )
    stripped = name.strip;
    parts = stripped.split('/');
    unless stripped.empty?
      if stripped.matches?(FORBIDDEN_NAME_CHARS) ||
         parts.any?(&.empty?) ||
         parts.any?(&.matches?(DOT_ONLY_NAME)) ||
         parts.any?(&.matches?(WINDOWS_RESERVED_NAMES))
        puts "Invalid name: #{name}.".colorize(:red);
        exit 0;
      end
    end
    @name = stripped.gsub(/\s+/, "-");
    @func_name = stripped.gsub(/[\s\/-]+/, "_");
  end

  # Contains the informational message for the user while performing an Emerald command
  #
  # return -> The string to display
  abstract def message;

  # A block of code to be executed for the command
  #
  # return -> The code block
  abstract def block;

  def separator
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  def run
    puts message.colorize(:white).mode(:bold);
    puts separator;

    elapsed = Time.measure { block.call }

    puts separator;
    puts "All done in #{elapsed
                          .total_seconds
                          .format(decimal_places: 3)} seconds"
      .colorize(:white)
      .mode(:bold);
  end
end
