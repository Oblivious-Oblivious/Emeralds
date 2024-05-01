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
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["release_opt"]} #{Emeralds.opt["release_version"]} #{Emeralds.opt["release_flags"]} #{Emeralds.opt["test_warnings"]} -o spec/#{Emeralds.opt["testoutput"]} #{Emeralds.opt["deps"]} #{Emeralds.opt["testinput"]}", display: true;
      puts;
      TerminalHandler.run "spec", Emeralds.opt["testoutput"], display: true;
    };
  end
end
