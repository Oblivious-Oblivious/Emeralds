# Shared build/install routines used by the build and install commands
class Emeralds::Build
  @displayed_deps = {} of String => Bool;

  private def move_headers_to_export
    Terminal.cp (File.join "src", "*"), "export";
    Terminal.rm (File.join "export", "*.c");
    Terminal.rm (File.join "export", "**", "*.c");
  end

  private def remove_objects_and_move_static_libs_to_export
    Terminal.rm Terminal.find(File.join(".", "*.o"));
    Terminal.rm Terminal.find(File.join(".", "*.obj"));
    Terminal.rm Terminal.find(File.join(".", "*.pdb"));
    Terminal.mv Terminal.find(File.join(".", "*.a")), "export";
    Terminal.mv Terminal.find(File.join(".", "*.a.test")), "export";
    Terminal.mv Terminal.find(File.join(".", "*.lib")).reject { |p| p.ends_with?(".test.lib") }, "export";
    Terminal.mv Terminal.find(File.join(".", "*.test.lib")), "export";
  end

  private def delete_excluded_paths(base_dir, exclude_patterns)
    base_dir_path = Path[base_dir];
    Dir.glob(base_dir_path.join("**", "{*,.*}"), match: File::MatchOptions.glob_default | File::MatchOptions::DotFiles) do |path|
      path = Path[path];
      relative_path = path.relative_to(base_dir_path).to_posix.to_s.lchop('/');
      next if exclude_patterns.any? do |pattern|
        pattern = pattern.lchop("./");
        pattern == relative_path || relative_path.starts_with?("#{pattern}/");
      end
      FileUtils.rm_rf(path.to_s) unless File.directory?(path.to_s) && path == base_dir_path;
    end
  end

  def msvc?(compile_flags)
    (compile_flags.first? || "").matches?(/\Acl(\.exe)?\z/i);
  end

  def build_app(compile_flags)
    Terminal.mkdir "export";

    if Terminal.sources_app.empty? && Terminal.input_app.empty?
      print "#{ARROW} ";
      puts "No main file found.".colorize(:red);
    else
      out_flag = msvc?(compile_flags) ? "/Fe:#{Terminal.output_app}" : "-o #{Terminal.output_app}";
      Terminal.generic_cmd "\
        #{compile_flags.join(' ')} \
        #{Terminal.deps_includes} \
        #{out_flag} \
        #{Terminal.deps_release} \
        #{Terminal.sources_app} \
        #{Terminal.input_app} \
      ", display: true;
      if msvc? compile_flags
        Terminal.rm Terminal.find(File.join(".", "*.obj"));
        Terminal.rm Terminal.find(File.join(".", "*.pdb"));
      end
    end
  end

  def build_lib(compile_flags, display = true)
    cc = compile_flags.first?;
    options = compile_flags.join(' ');
    includes = Terminal.deps_includes;
    sources = Terminal.sources_lib;
    release_out = msvc?(compile_flags) ? "#{Emfile.instance.name}.lib" : Terminal.output_lib;
    test_out = msvc?(compile_flags) ? "#{Emfile.instance.name}.test.lib" : "#{Terminal.output_lib}.test";
    if !sources.empty?
      if msvc? compile_flags
        Terminal.generic_cmd "#{options} #{includes} /c #{sources}", display: display;
        Terminal.generic_cmd "lib /nologo /OUT:#{release_out} *.obj", display: display;
        Terminal.generic_cmd "#{options} /std:clatest #{includes} /c #{sources}", display: display;
        Terminal.generic_cmd "lib /nologo /OUT:#{test_out} *.obj", display: display;
      else
        Terminal.generic_cmd "#{options} #{includes} -c #{sources}", display: display;
        Terminal.generic_cmd "#{cc} -o #{release_out} -r *.o", display: display;
        Terminal.generic_cmd "#{options} -std=c2x #{includes} -c #{sources}", display: display;
        Terminal.generic_cmd "#{cc} -o #{test_out} -r *.o", display: display;
      end
    end
    Terminal.mkdir "export";
    move_headers_to_export;
    remove_objects_and_move_static_libs_to_export;
  end

  def install_deps(deps, display = true)
    deps = deps.try(&.sanitize) || {} of String => String;
    pending_deps = {} of String => String;
    clones = Channel(Nil).new;
    clone_count = 0;

    deps.each do |key, value|
      name = Terminal.repo_name key;
      dep_path = File.join "libs", name;
      export_path = File.join dep_path, "export";

      if File.exists? export_path
        puts " #{COG} `#{name}` already installed." if display && !@displayed_deps[key]?;
        @displayed_deps[key] = true;
      else
        puts " #{COG} Installing `#{name}`" if display && !@displayed_deps[key]?;
        @displayed_deps[key] = true;
        pending_deps[key] = value;

        unless File.exists? dep_path
          clone_count += 1;
          spawn do
            if value == "latest"
              Terminal.git_clone key, dep_path;
            else
              Terminal.fetch_release key, value, dep_path;
            end
            clones.send nil;
          end
        end
      end
    end

    clone_count.times { clones.receive; };

    pending_deps.each do |key, value|
      name = Terminal.repo_name key;
      if File.exists? (File.join "libs", name)
        emfile_path = File.join "libs", name, "em.json";
        unless File.exists? emfile_path
          Terminal.rm (File.join "libs", name);
          next;
        end

        dep_emfile = Emfile.from_json File.read(emfile_path);
        install_deps dep_emfile.dependencies;

        Dir.cd (File.join "libs", name) do
          FileUtils.ln_s File.join("..", "..", "libs"), "libs" unless File.exists? "libs";
          Emfile.with_instance(dep_emfile) do
            build_lib dep_emfile.compile_flags.release, display: false;
          end
          delete_excluded_paths ".", ["export", "libs"];
          Terminal.rm ".git*";
          Terminal.rm ".clang*";
        end
      end
    end
  end
end
