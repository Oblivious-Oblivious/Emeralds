# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
  @name : String = "";
  getter :name;

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
    make_export;
    copy_headers;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["libs"]} $(#{Emeralds::OPT["inputfiles"]}) 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    copy_libraries_to_export;
  end

  # TODO - Compile into static libraries instead of shared

  # Main method that runs and times the command block.
  def run
    puts message.colorize(:white).mode(:bold);
    puts banner;

    elapsed = Time.measure { block.call; };

    puts banner;
    puts elapsed_time elapsed;
  end
end
