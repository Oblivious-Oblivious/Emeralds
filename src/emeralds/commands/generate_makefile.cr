require "./command"

class Emeralds::GenerateMakefile < Emeralds::Command
    def message
        "Emeralds - Generating a makefile...";
    end

    def block
        -> {
            cmd.generate_makefile;
        };
    end
end
