# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
  # Contains the informational message for the user while performing an Emerald command
  #
  # return -> The string to display
  abstract def message;

  # A block of code to be executed for the command
  #
  # return -> The code block
  abstract def block;

  # A random banner for enclosing output more clearly
  #
  # return -> The actual banner string
  private def banner
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  # Counts the elapsed time between execution blocks
  #
  # return -> A detailed string explained the time taken
  private def elapsed_time(elapsed)
    "All done in #{elapsed
      .total_seconds
      .format(decimal_places: 3)
    } seconds"
      .colorize(:white)
      .mode(:bold);
  end

  private def library_release
    return if try_override_command;

    make_export;
    copy_headers;
    TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["release_opt"]} #{Emeralds.opt["release_version"]} #{Emeralds.opt["release_flags"]} #{Emeralds.opt["release_warnings"]} #{Emeralds.opt["libs"]} #{Emeralds.opt["inputfiles"]}", display: true;
    copy_libraries_to_export;
  end

  private def validate_filename(input)
    forbidden_chars = /[<>:"\/\\|?*\x00-\x1F]/;
    windows_reserved = /^(con|prn|aux|nul|com[1-9]|lpt[1-9]|com[0-9]+|lpt[0-9]+)$/i;

    !(input.matches? forbidden_chars) &&
    !(input.strip.empty?) &&
    !(input.strip.matches? /\A\.+\z/) &&
    !(windows_reserved.matches? input.strip);
  end

  # Main method that runs and times the command block.
  def run
    puts message.colorize(:white).mode(:bold);
    puts banner;

    elapsed = Time.measure { block.call; };

    puts banner;
    puts elapsed_time elapsed;
  end
end
