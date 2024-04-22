abstract class Emeralds::Command
  private def make_export
    `rm -rf export && mkdir export`;
  end

  private def copy_headers
    `mkdir export/#{Emeralds::OPT["name"]} && mkdir export/#{Emeralds::OPT["name"]}/headers`;
    `cp -r src/#{Emeralds::OPT["name"]}/headers/* export/#{Emeralds::OPT["name"]}/headers/ >/dev/null 2>&1 || true`;
    `cp src/#{Emeralds::OPT["name"]}.h export/ >/dev/null 2>&1 || true`;
  end

  private def move_output_to_export
    `mv #{Emeralds::OPT["output"]} export/ >/dev/null 2>&1 || true`;
  end

  private def copy_libraries_to_export
    `mv *.o export/ >/dev/null 2>&1 || true`;
    `cp -r $(find ./libs -name "*.*o") export/ >/dev/null 2>&1 || true`;
  end
end
