class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      library_release;
      TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["release_opt"]} #{Emeralds.opt["release_version"]} #{Emeralds.opt["release_flags"]} #{Emeralds.opt["test_warnings"]} -o #{Emeralds.opt["testoutput"]} #{Emeralds.opt["deps"]} #{Emeralds.opt["testinput"]}", display: true;
      puts;
      TerminalHandler.run Emeralds.opt["testoutput"], display: true;
    };
  end
end
