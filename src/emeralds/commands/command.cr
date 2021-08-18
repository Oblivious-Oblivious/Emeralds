# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
    getter :cmd;

    def initialize
        @cmd = CommandProcessor.new;
    end

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
    def banner
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
    end

    # Counts the elapsed time between execution blocks
    #
    # return -> A detailed string explained the time taken
    def elapsed_time(elapsed)
        "All done in #{elapsed.total_seconds
            .format(decimal_places: 3)} seconds"
            .colorize(:white).mode(:bold);
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
