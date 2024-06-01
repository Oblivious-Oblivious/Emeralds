class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  # Runs the clean script defined in the em.json file
  def block
    -> {
      TerminalHandler.rm Emeralds.opt["test"]["output"], display: true;
      TerminalHandler.rm "export", display: true;
      TerminalHandler.rm "*.dSYM";
      TerminalHandler.rm "spec/*.dSYM";
      TerminalHandler.rm "export/*.dSYM";
    };
  end
end
