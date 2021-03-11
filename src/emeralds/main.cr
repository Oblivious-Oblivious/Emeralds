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
            Emeralds::Install.new.run;
        when "build"
            Emeralds::Build.new.run;
        when "test"
            Emeralds::Test.new.run;
        when "version"
            Emeralds::Version.new.run;
        when "clean"
            Emeralds::Clean.new.run;
        when "loc"
            Emeralds::Loc.new.run;
        when "help"
            Emeralds::Help.new.run;
        else
            Emeralds::Help.new.run;
        end
    end
end
