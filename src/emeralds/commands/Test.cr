class Emeralds::Test < Emeralds::Command
  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      if Emfile.cspec_exists
        library_release;
        cc = Emfile.instance.compile_flags.cc;
        opt = Emfile.instance.compile_flags.test.opt;
        version = Emfile.instance.compile_flags.test.version;
        flags = Emfile.instance.compile_flags.test.flags;
        warnings = Emfile.instance.compile_flags.test.warnings;
        deps = Emeralds.opt["test"]["deps"];
        input = Emeralds.opt["test"]["input"];
        output = Emeralds.opt["test"]["output"];
        TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} -o #{output} #{deps} #{input} 2> /dev/null", display: true;
        puts;
        TerminalHandler.run output, display: true;
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
