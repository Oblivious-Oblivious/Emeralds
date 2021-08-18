require "./command"

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
