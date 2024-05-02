module Emeralds::TerminalHandler
  def self.generic_cmd(cmd, display = false)
    puts "#{Emeralds.arrow} #{cmd}" if display;
    `#{cmd}`;
  rescue
    puts "#{cmd}: command not found".colorize(:light_red) if display;
  end

  def self.rm(path, display = false)
    puts "#{Emeralds.arrow} rm -rf #{path}" if display;
    Dir.glob path do |file_path|
      FileUtils.rm_rf file_path;
    end
  rescue
    puts "Could not remove #{path}".colorize(:light_red) if display;
  end

  def self.cp(src_dir, dest_dir, display = false)
    puts "#{Emeralds.arrow} cp -r #{src_dir} #{dest_dir}" if display;
    Dir.glob src_dir do |file_path|
      FileUtils.cp_r file_path, dest_dir;
    end
  rescue
    puts "Could not copy #{src_dir} to #{dest_dir}".colorize(:light_red) if display;
  end

  def self.mv(src_path, dest_path, display = false)
    puts "#{Emeralds.arrow} mv #{src_path} #{dest_path}" if display;
    Dir.glob src_path do |file_path|
      FileUtils.mv file_path, File.join(dest_path, File.basename(file_path));
    end
  rescue
    puts "Could not move #{src_path} to #{dest_path}".colorize(:light_red) if display;
  end

  def self.mkdir(path, display = false)
    unless Dir.exists? path
      puts "#{Emeralds.arrow} mkdir #{path}" if display;
    end
    FileUtils.mkdir_p path;
  rescue
    puts "Could not create directory: #{path}";
  end

  def self.run(executable, display = false)
    puts "#{Emeralds.arrow} ./#{executable}" if display;
    executable_path = File.join ".", executable;
    output = IO::Memory.new;
    Process.run executable_path, output: output;
    puts output.to_s;
  rescue
    puts "Could not run: ./#{executable}".colorize(:light_red) if display;
  end

  def self.wget(url, output, display = false)
    puts "#{Emeralds.arrow} wget -O #{output} #{url}" if display;
    HTTP::Client.get url do |response|
      File.open output, "w" do |file|
        IO.copy response.body_io, file;
      end
    end
  end

  def self.git_init(display = false)
    puts "#{Emeralds.arrow} git init";
    # TODO - Check for cross platform capability
    `git init`;
  end

  def self.git_clone(repo_url, repo_name, display = false)
    puts "#{Emeralds.arrow} git clone #{repo_url} #{repo_name}" if display;
    client = GitRepository::Generic.new repo_url;
    commit = client.commits(client.default_branch)[0].commit;
    client.fetch_commit commit, "#{repo_name}";
  rescue
    puts "Could not clone #{repo_url} to #{repo_name}".colorize(:light_red);
  end
end
