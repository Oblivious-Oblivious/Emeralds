class Emeralds::Test < Emeralds::Command
  private def build_test
    # TODO - Remove duplication (2 problems)
    #   ["deps"] needs to be an app and lib value
    #   we should not rebuild export directory (maybe pass a flag)
    if Terminal.input_test.empty?
      print "#{ARROW} ";
      puts "No main spec file found".colorize(:red);
    else
      Terminal.generic_cmd "\
        #{Emfile.instance.compile_flags.cc} \
        #{Emfile.instance.compile_flags.debug.opt} \
        #{"-std=c2x"} \
        #{Emfile.instance.compile_flags.debug.flags} \
        #{Emfile.instance.compile_flags.debug.warnings} \
        -o #{Terminal.output_test} \
        #{Terminal.deps_test} \
        #{Terminal.sources_test} \
        #{Terminal.input_test} \
      ", display: true;
      puts;
      Terminal.run Terminal.output_test, display: true;
    end
  end

  def message
    "Emeralds - Running tests...";
  end

  # Runs the test script defined in the em.yml file
  def block
    -> {
      if File.exists? File.join("libs", "cSpec", "export", "cSpec.h")
        Terminal.rm Terminal.output_test, display: true;
        Terminal.rm "spec/*.dSYM";
        build_test;
      elsif Emfile.cspec_not_on_deps && Emfile.cspec_not_on_dev_deps
        puts "cSpec is not in the list of dependencies".colorize(:red);
        puts "#{ARROW} Add the dependency like such:\ndev-dependencies:\n  cSpec: Oblivious-Oblivious/cSpec";
      else
        puts "Could not run tests becuase cSpec is not installed".colorize(:red);
        puts "#{ARROW} Please run `em install all`";
      end
    };
  end
end
