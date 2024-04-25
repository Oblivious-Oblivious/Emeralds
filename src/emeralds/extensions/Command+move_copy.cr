abstract class Emeralds::Command
  private def make_export
    `rm -rf export && mkdir export`;
  end

  private def copy_headers
    `cp -r src/* export/ >/dev/null 2>&1 || true`;
    `rm export/**/*.c >/dev/null 2>&1 || true`;
  end

  private def move_output_to_export
    `mv #{OPT["output"]} export/ >/dev/null 2>&1 || true`;
  end

  private def copy_libraries_to_export
    `mv *.o export/ >/dev/null 2>&1 || true`;
    `cp -r $(find ./libs -name "*.*o") export/ >/dev/null 2>&1 || true`;
  end
end
