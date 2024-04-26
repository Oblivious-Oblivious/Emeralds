class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  # Runs the clean script defined in the em.yml file
  def block
    -> {
      TerminalHandler.rm "spec/#{OPT["testoutput"]}", display: true;
      TerminalHandler.rm "export", display: true;
      TerminalHandler.generic_cmd "rm -rf *.dSYM";
    };
  end
end
