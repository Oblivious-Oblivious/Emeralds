class Emeralds::C::Build < Emeralds::Build
  private def sources_app
    c_files = Terminal.find(File.join("src", "*", "**", "*.c"));
    unix_libs = Terminal.find(File.join("src", "*", "**", "*.a"));
    msvc_libs = Terminal.find(File.join("src", "*", "**", "*.lib")).reject { |file|
      file.ends_with?(".test.lib");
    };
    (c_files + unix_libs + msvc_libs).shell_join;
  end

  private def sources_lib
    Terminal.find(File.join("src", "*", "**", "*.c")).shell_join;
  end

  private def deps_release
    unix_libs = Terminal.find(File.join("libs", "*", "export", "*.a"));
    msvc_libs = Terminal.find(File.join("libs", "*", "export", "*.lib")).reject { |file|
      file.ends_with?(".test.lib");
    };
    (unix_libs + msvc_libs).shell_join;
  end

  private def input_app
    Terminal.find(File.join("src", "*.c")).shell_join;
  end

  private def output_lib
    "#{Emfile.instance.name}.a".rstrip;
  end

  private def move_headers_to_export
    Terminal.cp (File.join "src", "*"), "export";
    Terminal.rm(File.join "export", "*.c");
    Terminal.rm(File.join "export", "**", "*.c");
  end

  private def remove_objects_and_move_static_libs_to_export
    Terminal.rm Terminal.find(File.join(".", "*.o"));
    Terminal.rm Terminal.find(File.join(".", "*.obj"));
    Terminal.rm Terminal.find(File.join(".", "*.pdb"));
    Terminal.mv Terminal.find(File.join(".", "*.a")), "export";
    Terminal.mv Terminal.find(File.join(".", "*.a.test")), "export";
    Terminal.mv Terminal.find(File.join(".", "*.lib")).reject(&.ends_with?(".test.lib")), "export";
    Terminal.mv Terminal.find(File.join(".", "*.test.lib")), "export";
  end

  def output_app
    "#{File.join("export", (Emfile.instance.name || ""))}".rstrip;
  end

  def deps_includes
    paths = [] of String;

    Dir.glob(File.join("libs", "*", "export").posix_path) do |path|
      paths << path if File.directory? path;
    end
    Dir.glob(File.join("libs", "*", "export", "**").posix_path) do |path|
      paths << path if File.directory? path;
    end

    paths.uniq.map { |path| "-I#{path}" }.shell_join;
  end

  def msvc?(compile_flags)
    (compile_flags.first? || "").matches?(/\Acl(\.exe)?\z/i);
  end

  def build_app(compile_flags)
    Terminal.mkdir "export";

    if sources_app.empty? && input_app.empty?
      print "#{ARROW} ";
      puts "No main file found.".colorize(:red);
    else
      out_flag = msvc?(compile_flags) ? "/Fe:#{output_app}" : "-o #{output_app}";
      Terminal.generic_cmd "#{compile_flags.join(' ')} #{deps_includes} #{out_flag} #{deps_release} #{sources_app} #{input_app}", display: true;
      if msvc? compile_flags
        Terminal.rm Terminal.find(File.join(".", "*.obj"));
        Terminal.rm Terminal.find(File.join(".", "*.pdb"));
      end
    end
  end

  def build_lib(compile_flags, display = true)
    cc = compile_flags.first?;
    options = compile_flags.join(' ');
    includes = deps_includes;
    sources = sources_lib;
    release_out = msvc?(compile_flags) ? "#{Emfile.instance.name}.lib" : output_lib;
    test_out = msvc?(compile_flags) ? "#{Emfile.instance.name}.test.lib" : "#{output_lib}.test";
    if !sources.empty?
      if msvc? compile_flags
        Terminal.generic_cmd "#{options} #{includes} /c #{sources}", display: display;
        Terminal.generic_cmd "lib /nologo /OUT:#{release_out} *.obj", display: display;
        Terminal.generic_cmd "#{options} /std:clatest #{includes} /c #{sources}", display: display;
        Terminal.generic_cmd "lib /nologo /OUT:#{test_out} *.obj", display: display;
      else
        Terminal.generic_cmd "#{options} #{includes} -c #{sources}", display: display;
        Terminal.generic_cmd "#{cc} -o #{release_out} -r *.o", display: display;
        Terminal.generic_cmd "#{options} -std=c23 #{includes} -c #{sources}", display: display;
        Terminal.generic_cmd "#{cc} -o #{test_out} -r *.o", display: display;
      end
    end
    Terminal.mkdir "export";
    move_headers_to_export;
    remove_objects_and_move_static_libs_to_export;
  end
end
