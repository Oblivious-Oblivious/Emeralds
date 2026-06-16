class Emeralds::C::Install < Emeralds::Install
  @displayed_deps = {} of String => Bool;
  @dependency_links = [] of String;

  private def delete_excluded_paths(base_dir, exclude_patterns)
    base_dir_path = Path[base_dir];
    Dir.glob(base_dir_path.join("**", "{*,.*}"), match: File::MatchOptions.glob_default | File::MatchOptions::DotFiles) do |path|
      path = Path[path];
      relative_path = path.relative_to(base_dir_path).to_posix.to_s.lchop('/');
      next if exclude_patterns.any? do |pattern|
                pattern = pattern.lchop("./");
                pattern == relative_path || relative_path.starts_with?("#{pattern}/");
              end
      FileUtils.rm_rf(path) unless File.directory?(path) && path == base_dir_path;
    end
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

    clone_count.times { clones.receive }

    pending_deps.each do |key, _|
      name = Terminal.repo_name key;
      if File.exists?(File.join "libs", name)
        emfile_path = File.join "libs", name, "em.json";
        unless File.exists? emfile_path
          Terminal.rm(File.join "libs", name);
          next;
        end

        dep_emfile = Emfile.from_json File.read(emfile_path);
        dep_emfile.link.try { |link| @dependency_links.concat link };
        install_deps dep_emfile.dependencies;

        Dir.cd (File.join "libs", name) do
          FileUtils.ln_s File.join("..", "..", "libs"), "libs" unless File.exists? "libs";
          Emfile.with_instance(dep_emfile) do
            C::Build.new.build_lib dep_emfile.compile_flags.release, display: false;
          end
          delete_excluded_paths ".", ["export", "libs"];
          Terminal.rm ".git*";
          Terminal.rm ".clang*";
        end
      end
    end
  end

  private def prune_undeclared
    declared = [Emfile.instance.dependencies, Emfile.instance.dev_dependencies]
      .compact
      .flat_map(&.keys)
      .map { |key| Terminal.repo_name key };

    Dir.glob(File.join "libs", "*") do |path|
      next unless File.directory? path;
      next if declared.includes? File.basename path;
      Terminal.rm path;
      puts " #{COG} Removed `#{File.basename path}` from libs.";
    end
  end

  def promote_links
    links = @dependency_links.uniq;
    return if links.empty?;

    json = JSON.parse(File.read "em.json");
    compile_flags = json["compile-flags"]?;
    return unless compile_flags;

    changed = false;
    compile_flags.as_h.each_value do |platform|
      next unless platform.as_h?;

      platform.as_h.each_value do |mode_flags|
        next unless mode_flags.as_a?;

        current = mode_flags.as_a.compact_map(&.as_s?);
        next if current.empty?;

        to_add = links - current;
        next if to_add.empty?;

        to_add.each { |link| mode_flags.as_a << JSON::Any.new(link) };
        changed = true;
      end;
    end;

    File.write "em.json", json.to_pretty_json if changed;
  end

  def block
    -> {
      Terminal.mkdir "libs";
      install_deps Emfile.instance.dependencies;
      prune_undeclared;
      promote_links;
    };
  end
end
