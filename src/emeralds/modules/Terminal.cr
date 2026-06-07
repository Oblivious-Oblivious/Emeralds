module Emeralds::Terminal
  def self.generic_cmd(cmd, display = false)
    puts "#{ARROW} #{cmd}" if display;
    error = display ? Process::Redirect::Inherit : Process::Redirect::Close;
    Process.run cmd, shell: true, output: Process::Redirect::Inherit, error: error;
  rescue
    puts "#{cmd}: command not found".colorize(:red) if display;
  end

  def self.rm(path, display = false)
    puts "#{ARROW} remove #{path}" if display;
    pattern = path.is_a?(String) ? path.posix_path : path.map(&.posix_path);
    Dir.glob pattern do |file_path|
      FileUtils.rm_rf file_path;
    end
  rescue
    puts "Could not remove #{path}".colorize(:red) if display;
  end

  def self.cp(src_dir, dest_dir, display = false)
    puts "#{ARROW} copy #{src_dir} to #{dest_dir}" if display;
    Dir.glob src_dir.posix_path do |file_path|
      FileUtils.cp_r file_path, dest_dir;
    end
  rescue
    puts "Could not copy #{src_dir} to #{dest_dir}".colorize(:red) if display;
  end

  def self.mv(src_path, dest_path, display = false)
    puts "#{ARROW} move #{src_path.join ' '} to #{dest_path}" if display;
    FileUtils.mv src_path, dest_path;
  rescue
    puts "Could not move #{src_path} to #{dest_path}".colorize(:red) if display;
  end

  def self.mkdir(path, display = false)
    unless Dir.exists? path
      puts "#{ARROW} create directory #{path}" if display;
    end
    FileUtils.mkdir_p path;
  rescue
    puts "Could not create directory: #{path}" if display;
  end

  def self.run(executable, display = false)
    puts "#{ARROW} run #{executable}\n\n" if display;
    executable_path = File.join ".", executable;
    status = Process.run executable_path,
      input: Process::Redirect::Inherit,
      output: Process::Redirect::Inherit,
      error: Process::Redirect::Inherit;

    raise "Process failed with exit status: #{status.exit_code}" if !status.success?;
  rescue ex
    puts "#{ex.message}".colorize(:red) if display;
  end

  def self.wget(url, output, display = false)
    puts "#{ARROW} download #{url} #{output}" if display;
    HTTP::Client.get url do |response|
      File.open output, "w" do |file|
        IO.copy response.body_io, file;
      end
    end
  end

  def self.git_init(display = false)
    puts "#{ARROW} git init" if display;
    status = Process.run "git", ["init"], output: Process::Redirect::Close, error: Process::Redirect::Close;
    raise "git init failed" unless status.success?;
  rescue
    puts "Could not initialize git repository.".colorize(:red);
  end

  def self.git_clone(repo_url, repo_name, display = false)
    puts "#{ARROW} git clone #{repo_url} #{repo_name}" if display;
    status = Process.run "git", ["clone", "--depth", "1", repo_url, repo_name], output: Process::Redirect::Close, error: Process::Redirect::Close;
    raise "git clone failed" unless status.success?;
  rescue
    puts "Could not clone #{repo_url} to #{repo_name}".colorize(:red);
  end

  def self.repo_name(link)
    File.basename link.strip.rchop('/').rchop(".git");
  end

  def self.download(url, output)
    location = url;
    5.times do
      HTTP::Client.get location do |response|
        if response.status.redirection? && (target = response.headers["location"]?)
          location = target;
        elsif response.success?
          File.open(output, "w") { |file| IO.copy response.body_io, file }
          return true;
        else
          return false;
        end
      end
    end
    false;
  end

  def self.unzip(zip_path, dest_dir)
    Compress::Zip::File.open zip_path do |zip|
      zip.entries.each do |entry|
        path = entry.filename.split('/', 2)[1]?;
        next if path.nil? || path.blank?;
        target = File.join dest_dir, path;
        if entry.dir?
          FileUtils.mkdir_p target;
        else
          FileUtils.mkdir_p File.dirname(target);
          entry.open { |io| File.open(target, "w") { |file| IO.copy io, file } }
        end
      end
    end
  end

  def self.fetch_release(link, version, dest_dir, display = false)
    zip_path = "#{dest_dir}.zip";
    tags = version.starts_with?("v") ? [version] : [version, "v#{version}"];

    tags.each do |tag|
      url = "#{link}/archive/refs/tags/#{tag}.zip";
      puts "#{ARROW} download #{url}" if display;
      next unless download url, zip_path;
      unzip zip_path, dest_dir;
      File.delete zip_path;
      return;
    end

    puts "Could not download #{link} #{version}".colorize(:red);
  end

  def self.find(path)
    matches = [] of String;

    Dir.glob(path.posix_path) do |file|
      matches << file if File.file? file
    end

    matches.uniq! { |file| File.basename file };
  end
end
