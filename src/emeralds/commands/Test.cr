class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      if Emfile.cspec_exists
        TerminalHandler.rm Emeralds.opt["test"]["output"], display: true;
        TerminalHandler.rm "spec/*.dSYM";
        build_test;
      elsif Emfile.cspec_dep_does_not_exist
        puts "cSpec is not in the list of dependencies".colorize(:light_red);
        puts "#{Emeralds.arrow} Add the dependency like such:\ndev-dependencies:\n  cSpec: Oblivious-Oblivious/cSpec";
      else
        puts "Could not run tests becuase cSpec is not installed".colorize(:light_red);
        puts "#{Emeralds.arrow} Please run `em install all`";
      end
    };
  end
end
