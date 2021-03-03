require "./emeralds/**"

module Emeralds
    COG       = "⚙".colorize(:light_green).mode(:dim).to_s;
    ARROW     = "➔".colorize(:dark_gray).to_s;
    CHECKMARK = "✔".colorize(:light_green).to_s;
    DIAMOND   = "◈";
end

class Emeralds::Main
    getter :cmd;

    def initialize
        @cmd = CommandProcessor.new;
    end

    def run
        cmd.usage if ARGV.size < 1;
        action = ARGV[0];

        case action
        when "init"
            elapsed = Time.measure do
                cmd.usage if ARGV.size < 2;
                cmd.initialize_em_library ARGV[1];
            end
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "list"
            elapsed = Time.measure { cmd.get_dependencies; };
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "install"
            elapsed = Time.measure { cmd.install_dependencies; };
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "build"
            elapsed = Time.measure do
                cmd.usage if ARGV.size < 2;
                if ARGV[1] == "app"
                    cmd.compile_as_executable;
                elsif ARGV[1] == "lib"
                    cmd.compile_as_library;
                else
                    cmd.usage;
                end
            end
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "test"
            elapsed = Time.measure { cmd.run_test_script; };
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "version"
            elapsed = Time.measure { puts cmd.get_em_version; };
            puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "help"
            cmd.usage;
        when "clean"
            elapsed = Time.measure { cmd.run_clean_script; };
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        when "loc"
            elapsed = Time.measure do
                data = cmd.count_lines_of_code;
                puts "  #{COG} Files: #{data[0].to_s.colorize(:white).mode(:bold)}";
                puts "  #{COG} Lines of code: #{data[1].to_s.colorize(:white).mode(:bold)}"
                puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
            end
            puts "All done in #{elapsed.total_seconds
                .format(decimal_places: 3)} seconds"
                .colorize(:white).mode(:bold);
        else
            cmd.usage;
        end
    end
end

Emeralds::Main.new.run;
