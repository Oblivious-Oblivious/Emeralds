abstract class Emeralds::Command
  private def make_export
    TerminalHandler.rm "export";
    TerminalHandler.mkdir "export";
  end

  private def copy_headers
    TerminalHandler.generic_cmd "cp -r src/* export/ >/dev/null 2>&1 || true";
    TerminalHandler.rm "rm -rf export/*.c";
    TerminalHandler.rm "rm -rf export/**/*.c";
  end

  private def move_output_to_export
    TerminalHandler.generic_cmd "mv #{OPT["output"]} export/ >/dev/null 2>&1 || true";
  end

  private def copy_libraries_to_export
    TerminalHandler.generic_cmd "mv *.o export/ >/dev/null 2>&1 || true";
    TerminalHandler.generic_cmd "cp -r $(find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true";
  end
end
