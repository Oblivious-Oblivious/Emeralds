require "./command"

class Emeralds::Install < Emeralds::Command
    def message
        "Emeralds - Resolving dependencies...";
    end

    def block
        -> {
            cmd.install_dependencies;
        };
    end
end
