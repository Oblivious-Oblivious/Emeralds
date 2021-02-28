require "./emeralds/**"

class Emerald::Main
    getter :cmd;

    def initialize
        @cmd = CommandProcessor.new;
    end

    def run
        cmd.usage if ARGV.size < 1;
        action = ARGV[0];

        case action
        when "init"
            cmd.usage if ARGV.size < 2;
            cmd.initialize_em_library ARGV[1];
        when "list"
            cmd.get_dependencies;
        when "install"
            cmd.install_dependencies;
        when "build"
            cmd.usage if ARGV.size < 2;
            if ARGV[1] == "app"
                cmd.compile_as_executable;
            elsif ARGV[1] == "lib"
                cmd.compile_as_library;
            else
                cmd.usage;
            end
        when "test"
            cmd.run_test_script;
        when "version"
            puts cmd.get_em_version;
        when "help"
            cmd.usage;
        when "clean"
            cmd.run_clean_script;
        else
            cmd.usage;
        end
    end
end

Emerald::Main.new.run;
