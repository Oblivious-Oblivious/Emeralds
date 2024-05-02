abstract class Emeralds::Command
  private def make_export
    TerminalHandler.rm "export";
    TerminalHandler.mkdir "export";
  end

  private def copy_headers
    TerminalHandler.cp (File.join "src", "*"), "export";
    TerminalHandler.rm (File.join "export", "*.c");
    TerminalHandler.rm (File.join "export", "**", "*.c");
  end

  private def move_libraries_to_export
    TerminalHandler.mv "#{FileHandler.find_with_pattern(File.join(".", "**", "*.o")).join ' '}", "export";
  end
end
