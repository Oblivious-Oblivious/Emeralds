require "./command_processor"
require "./commands/**"

class Emeralds::Main
    def run
        Emeralds::Help.new.run if ARGV.size < 1;
        action = ARGV[0];

        case action
        when "init"
            Emeralds::Init.new.run;
        when "list"
            Emeralds::List.new.run;
        when "install"
            if ARGV.size < 2
                Emeralds::Install.new.run;
            elsif ARGV[1] == "dev"
                Emeralds::InstallDev.new.run;
            else
                Emeralds::Help.new.run;
            end
        when "build"
            if ARGV[1] == "app"
                Emeralds::Build.new.run;
            elsif ARGV[1] == "lib"
                Emeralds::BuildLibrary.new.run;
            else
                Emeralds::Help.new.run;
            end
        when "test"
            Emeralds::Test.new.run;
        when "version"
            Emeralds::Version.new.run;
        when "clean"
            Emeralds::Clean.new.run;
        when "loc"
            if ARGV.size < 2
                Emeralds::Loc.new.run;
            elsif ARGV[1] == "deps"
                Emeralds::LocDeps.new.run;
            else
                Emeralds::Help.new.run;
            end
        when "help"
            Emeralds::Help.new.run;
        else
            Emeralds::Help.new.run;
        end
    end
end
