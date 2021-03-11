abstract class Emeralds::Command
    getter :cmd;

    def initialize
        @cmd = CommandProcessor.new;
    end

    abstract def message;
    abstract def block;

    def banner : String
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
    end

    def elapsed_time(elapsed)
        "All done in #{elapsed.total_seconds
            .format(decimal_places: 3)} seconds"
            .colorize(:white).mode(:bold);
    end

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
            if ARGV.size < 2
                cmd.install_dependencies;
            elsif ARGV.size == 2 && ARGV[1] == "dev"
                cmd.install_dev_dependencies;
            else
                cmd.usage;
            end
        };
    end
end

class Emeralds::Build < Emeralds::Command
    def message
        "Emeralds - Compiling ...";
    end

    def block
        -> {
            cmd.usage if ARGV.size < 2;
            if ARGV[1] == "app"
                cmd.compile_as_executable;
            elsif ARGV[1] == "lib"
                cmd.compile_as_library;
            else
                cmd.usage;
            end
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
            puts "  #{COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}"
        };
    end
end

class Emeralds::Help < Emeralds::Command
    def message
        "";
    end

    def block
        -> {
            cmd.usage;
        };
    end
end
