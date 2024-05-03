class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      if YamlReader.cspec_exists
        library_release;
        TerminalHandler.generic_cmd "#{Emeralds.opt["cc"]} #{Emeralds.opt["release_opt"]} #{Emeralds.opt["release_version"]} #{Emeralds.opt["release_flags"]} #{Emeralds.opt["test_warnings"]} -o #{Emeralds.opt["testoutput"]} #{Emeralds.opt["deps"]} #{Emeralds.opt["testinput"]} 2> /dev/null", display: true;
        puts;
        TerminalHandler.run Emeralds.opt["testoutput"], display: true;
      elsif YamlReader.cspec_dep_does_not_exist
        puts "cSpec is not in the list of dependencies".colorize(:light_red);
        puts "#{Emeralds.arrow} Add the dependency like such:\ndev-dependencies:\n  cSpec: Oblivious-Oblivious/cSpec";
      else
        puts "Could not run tests becuase cSpec is not installed".colorize(:light_red);
        puts "#{Emeralds.arrow} Please run `em install all`";
      end
    };
  end
end
