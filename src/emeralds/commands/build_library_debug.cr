require "./command"

class Emeralds::BuildLibraryDebug < Emeralds::Command
    def message
        "Emeralds - Compiling as a library...";
    end

    def block
        -> {
            cmd.compile_as_library "debug";
        };
    end
end
