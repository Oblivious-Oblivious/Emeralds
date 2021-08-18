require "./command"

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
