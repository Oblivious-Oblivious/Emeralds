class Emeralds::Test < Emeralds::Command
  private def build_test
    if Terminal.input_test.empty?
      print "#{ARROW} ";
      puts "No main spec file found".colorize(:red);
    else
      driver = msvc? ? "#{Emfile.instance.compile_flags.cc} /nologo" : Emfile.instance.compile_flags.cc.to_s;
      std_flag = msvc? ? "/std:clatest" : "-std=c2x";
      out_target = msvc? ? "#{Terminal.output_test}.exe" : Terminal.output_test;
      out_flag = msvc? ? "/Fe:#{out_target}" : "-o #{out_target}";
      Terminal.generic_cmd "\
        #{driver} \
        #{Emfile.instance.compile_flags.debug.opt} \
        #{std_flag} \
        #{Emfile.instance.compile_flags.debug.flags} \
        #{Emfile.instance.compile_flags.debug.warnings} \
        #{Terminal.deps_includes} \
        #{out_flag} \
        #{Terminal.deps_for_test} \
        #{Terminal.sources_test} \
        #{Terminal.input_test} \
        #{Emfile.instance.compile_flags.debug.libs} \
      ", display: true;
      if msvc?
        Terminal.rm Terminal.find(File.join(".", "*.obj"));
        Terminal.rm Terminal.find(File.join(".", "*.pdb"));
      end
      puts;
      Terminal.run out_target, display: true;
    end
  end

  def message
    "Emeralds - Running tests...";
  end

  def block
    -> {
      if File.exists? File.join("libs", "cSpec", "export", "cSpec.h")
        Terminal.rm Terminal.output_test, display: true;
        Terminal.rm "#{Terminal.output_test}.exe", display: true;
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
