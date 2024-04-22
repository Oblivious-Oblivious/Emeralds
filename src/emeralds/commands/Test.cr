class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      copy_libraries_to_export;
      library_release;
      cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["test_warnings"]} -o spec/#{Emeralds::OPT["testoutput"]} $(#{Emeralds::OPT["deps"]}) $(#{Emeralds::OPT["testinput"]}) 2>&1 | grep -v \"no input files\"";
      `mkdir export >/dev/null 2>&1 || true`;
      puts cmd;
      `#{cmd}`;
      puts;
      puts "./spec/#{Emeralds::OPT["testoutput"]}";
      puts `./spec/#{Emeralds::OPT["testoutput"]}`;
    };
  end
end
