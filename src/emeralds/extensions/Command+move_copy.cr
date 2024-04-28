abstract class Emeralds::Command
  private def make_export
    TerminalHandler.rm "export";
    TerminalHandler.mkdir "export";
  end

  private def copy_headers
    TerminalHandler.cp "src/*", "export/";
    TerminalHandler.rm "export/*.c";
    TerminalHandler.rm "export/**/*.c";
  end

  private def move_output_to_export
    TerminalHandler.mv "#{OPT["output"]}", "export/";
  end

  private def copy_libraries_to_export
    TerminalHandler.mv "*.o", "export/";
    TerminalHandler.cp "#{FileHandler.find_with_pattern "./libs", "*.o"}", "export/";
  end
end
