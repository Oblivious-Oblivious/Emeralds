require "./command"

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
