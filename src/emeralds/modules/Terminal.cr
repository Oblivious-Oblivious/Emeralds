module Emeralds::Terminal
  # TODO - Ideally replace all generic comamnds with cross-platform equivalents
  def self.generic_cmd(cmd, display = false)
    puts "#{ARROW} #{cmd}" if display;
    `#{cmd}`;
  rescue
    puts "#{cmd}: command not found".colorize(:red) if display;
  end

  def self.rm(path, display = false)
    puts "#{ARROW} rm -rf #{path}" if display;
    Dir.glob path do |file_path|
      FileUtils.rm_rf file_path;
    end
  rescue
    puts "Could not remove #{path}".colorize(:red) if display;
  end

  def self.cp(src_dir, dest_dir, display = false)
    puts "#{ARROW} cp -r #{src_dir} #{dest_dir}" if display;
    Dir.glob src_dir do |file_path|
      FileUtils.cp_r file_path, dest_dir;
    end
  rescue
    puts "Could not copy #{src_dir} to #{dest_dir}".colorize(:red) if display;
  end

  def self.mv(src_path, dest_path, display = false)
    puts "#{ARROW} mv #{src_path.join ' '} #{dest_path}" if display;
    FileUtils.mv src_path, dest_path;
  rescue
    puts "Could not move #{src_path} to #{dest_path}".colorize(:red) if display;
  end

  def self.mkdir(path, display = false)
    unless Dir.exists? path
      puts "#{ARROW} mkdir #{path}" if display;
    end
    FileUtils.mkdir_p path;
  rescue
    puts "Could not create directory: #{path}" if display;
  end

  def self.run(executable, display = false)
    puts "#{ARROW} ./#{executable}" if display;
    executable_path = File.join ".", executable;
    output = IO::Memory.new;
    error = IO::Memory.new;
    status = Process.run executable_path, output: output, error: error;

    puts output.to_s;
    raise "Process failed with exit status: #{status.exit_code}" if !status.success?;
  rescue ex
    puts error.to_s;
    puts "#{ex.message}".colorize(:red) if display;
  end

  def self.wget(url, output, display = false)
    puts "#{ARROW} wget -O #{output} #{url}" if display;
    HTTP::Client.get url do |response|
      File.open output, "w" do |file|
        IO.copy response.body_io, file;
      end
    end
  end

  def self.git_init(display = false)
    puts "#{ARROW} git init" if display;
    # TODO - Check for cross platform capability
    `git init`;
  end

  def self.git_clone(repo_url, repo_name, display = false)
    puts "#{ARROW} git clone #{repo_url} #{repo_name}" if display;
    client = GitRepository::Generic.new repo_url;
    commit = client.commits(client.default_branch)[0].commit;
    client.fetch_commit commit, "#{repo_name}";
  rescue
    puts "Could not clone #{repo_url} to #{repo_name}".colorize(:red);
  end

  # Search for all patterns in start_dir (command emulates linux find start_dir -name pattern)
  #
  # return -> An array of matches
  def self.find(path)
    matches = [] of String;

    Dir.glob(path) do |file|
      matches << file if File.file? file
    end

    matches.uniq! { |path| path.split('/').last };
  end

  def self.sources_app
    "#{find(File.join("src", "*", "**", "*.c")).join(' ')} #{find(File.join("src", "*", "**", "*.a")).join(' ')}".rstrip;
  end

  def self.sources_lib
    "#{find(File.join("src", "*", "**", "*.c")).join(' ')}".rstrip;
  end

  def self.sources_test
    "#{find(File.join("src", "*", "**", "*.c")).join(' ')} #{find(File.join("src", "*", "**", "*.a.test")).join(' ')}".rstrip;
  end

  def self.deps_release
    "#{find(File.join("libs", "*", "export", "*.a")).join(' ')}".rstrip;
  end

  def self.deps_test
    "#{find(File.join("libs", "*", "export", "*.a.test")).join(' ')}".rstrip;
  end

  def self.input_app
    "#{find(File.join("src", "*.c")).join(' ')}".rstrip;
  end

  def self.input_test
    "#{find(File.join("spec", "*.spec.c")).join(' ')}".rstrip;
  end

  def self.output_app
    "#{File.join("export", Emfile.instance.name)}".rstrip;
  end

  def self.output_lib
    "#{Emfile.instance.name}.a".rstrip;
  end

  def self.output_test
    "#{File.join("spec", "spec_results")}".rstrip;
  end
end
