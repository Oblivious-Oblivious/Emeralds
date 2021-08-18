require "./command"

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
