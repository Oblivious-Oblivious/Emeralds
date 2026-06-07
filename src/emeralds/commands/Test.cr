class Emeralds::Test < Emeralds::Command
  def output_test
    "#{File.join("spec", "spec_results")}".rstrip;
  end

  private def sources_test
    c_files = Terminal.find(File.join("src", "*", "**", "*.c"));
    unix_libs = Terminal.find(File.join("src", "*", "**", "*.a.test"));
    msvc_libs = Terminal.find(File.join("src", "*", "**", "*.test.lib"));
    (c_files + unix_libs + msvc_libs).shell_join;
  end

  private def deps_for_test
    deps = [] of String;

    Dir.glob(File.join("libs", "*", "export").posix_path) do |path|
      test_libs = Terminal.find(File.join(path, "*.a.test")) + Terminal.find(File.join(path, "*.test.lib"));
      release_libs = Terminal.find(File.join(path, "*.a")) + Terminal.find(File.join(path, "*.lib")).reject { |file|
        file.ends_with?(".test.lib");
      };
      deps.concat test_libs.empty? ? release_libs : test_libs;
    end

    deps.shell_join;
  end

  private def input_test
    Terminal.find(File.join("spec", "*.spec.c")).shell_join;
  end

  private def build_test
    if input_test.empty?
      print "#{ARROW} ";
      puts "No main spec file found.".colorize(:red);
    else
      compile_flags = Emfile.instance.compile_flags.debug;
      build = C::Build.new;
      std_flag = build.msvc?(compile_flags) ? "/std:clatest" : "-std=c2x";
      out_target = build.msvc?(compile_flags) ? "#{output_test}.exe" : output_test;
      out_flag = build.msvc?(compile_flags) ? "/Fe:#{out_target}" : "-o #{out_target}";
      Terminal.generic_cmd "#{compile_flags.join(' ')} #{std_flag} #{build.deps_includes} #{out_flag} #{deps_for_test} #{sources_test} #{input_test}", display: true;
      if build.msvc? compile_flags
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
        Terminal.rm output_test, display: true;
        Terminal.rm "#{output_test}.exe", display: false;
        Terminal.rm "spec/*.dSYM";
        build_test;
      elsif Emfile.cspec_not_on_deps && Emfile.cspec_not_on_dev_deps
        puts "cSpec is not in the list of dependencies.".colorize(:red);
        puts "#{ARROW} Add the dependency like such:\ndev-dependencies:\n  \"https://github.com/Oblivious-Oblivious/cSpec\": \"latest\"";
      else
        puts "Could not run tests becuase cSpec is not installed.".colorize(:red);
        puts "#{ARROW} Please run `em install all`";
      end
    };
  end
end
