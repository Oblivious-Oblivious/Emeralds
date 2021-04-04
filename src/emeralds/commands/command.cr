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

class Emeralds::Init < Emeralds::Command
    def message
        "Emeralds - Initializing a new project";
    end

    def block
        -> {
            cmd.usage if ARGV.size < 2;
            cmd.initialize_em_library ARGV[1];
        };
    end
end

class Emeralds::List < Emeralds::Command
    def message
        "Emeralds - Em libraries used:";
    end

    def block
        -> {
            cmd.get_dependencies;
        };
    end
end

class Emeralds::Install < Emeralds::Command
    def message
        "Emeralds - Resolving dependencies...";
    end

    def block
        -> {
            cmd.install_dependencies;
        };
    end
end

class Emeralds::InstallDev < Emeralds::Command
    def message
        "Emeralds - Resolving development dependencies...";
    end

    def block
        -> {
            cmd.install_dev_dependencies;
        };
    end
end

class Emeralds::BuildDebug < Emeralds::Command
    def message
        "Emeralds - Compiling as an app...";
    end

    def block
        -> {
            cmd.compile_as_executable "debug";
        };
    end
end

class Emeralds::BuildRelease < Emeralds::Command
    def message
        "Emeralds - Compiling as an app...";
    end

    def block
        -> {
            cmd.compile_as_executable "release";
        };
    end
end

class Emeralds::BuildLibraryDebug < Emeralds::Command
    def message
        "Emeralds - Compiling as a library...";
    end

    def block
        -> {
            cmd.compile_as_library "debug";
        };
    end
end

class Emeralds::BuildLibraryRelease < Emeralds::Command
    def message
        "Emeralds - Compiling as a library...";
    end

    def block
        -> {
            cmd.compile_as_library "release";
        };
    end
end

class Emeralds::Test < Emeralds::Command
    def message
        "Emeralds - Running tests...";
    end

    def block
        -> {
            cmd.run_test_script;
        };
    end
end

class Emeralds::Version < Emeralds::Command
    def message
        "Emeralds - Version";
    end

    def block
        -> {
            puts cmd.get_em_version;
        };
    end
end

class Emeralds::Clean < Emeralds::Command
    def message
        "Emeralds - Cleaning the library files...";
    end

    def block
        -> {
            cmd.run_clean_script;
        };
    end
end

class Emeralds::Loc < Emeralds::Command
    def message
        "Counting Lines of Code...";
    end

    def block
        -> {
            data = cmd.count_lines_of_code;
            puts "  #{COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
            puts "  #{COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
        };
    end
end

class Emeralds::LocDeps < Emeralds::Command
    def message
        "Counting Lines of Code for dependencies...";
    end

    def block
        -> {
            data = cmd.count_deps_lines_of_code;
            puts "  #{COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
            puts "  #{COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}";
        }
    end
end

class Emeralds::Help < Emeralds::Command
    def message
        "Emeralds - Help/Usage";
    end

    def block
        -> {
            cmd.usage;
            exit 0;
        };
    end
end
