class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      copy_libraries_to_export;
      library_release;
      cmd = "#{OPT["cc"]} #{OPT["release_opt"]} #{OPT["release_version"]} #{OPT["release_flags"]} #{OPT["test_warnings"]} -o spec/#{OPT["testoutput"]} $(#{OPT["deps"]}) $(#{OPT["testinput"]})";
      `mkdir export >/dev/null 2>&1 || true`;
      puts cmd;
      `#{cmd}`;
      puts;
      puts "./spec/#{OPT["testoutput"]}";
      puts `./spec/#{OPT["testoutput"]}`;
    };
  end
end
