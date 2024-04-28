class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      copy_libraries_to_export;
      library_release;
      TerminalHandler.mkdir "export";
      # NOTE - We bypass optimization and re-evaluate dependecy paths.
      OPT["deps"] = FileHandler.find_with_pattern("./export", "*.o").join ' ';
      TerminalHandler.generic_cmd "#{OPT["cc"]} #{OPT["release_opt"]} #{OPT["release_version"]} #{OPT["release_flags"]} #{OPT["test_warnings"]} -o spec/#{OPT["testoutput"]} #{OPT["deps"]} #{OPT["testinput"]}", display: true;
      puts;
      puts TerminalHandler.generic_cmd "./spec/#{OPT["testoutput"]}", display: true;
    };
  end
end
