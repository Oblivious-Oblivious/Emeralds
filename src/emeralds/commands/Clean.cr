class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  # Runs the clean script defined in the em.yml file
  def block
    -> {
      TerminalHandler.rm Emeralds.opt["testoutput"], display: true;
      TerminalHandler.rm "export", display: true;
      TerminalHandler.rm "*.dSYM";
    };
  end
end
