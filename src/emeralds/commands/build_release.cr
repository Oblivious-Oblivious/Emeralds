require "./command"

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
