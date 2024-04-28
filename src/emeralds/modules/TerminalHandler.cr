module Emeralds::TerminalHandler
  def self.generic_cmd(cmd, display = false)
    puts "#{ARROW} #{cmd}" if display;
    `#{cmd}`;
  rescue
    puts "#{cmd}: command not found".colorize(:light_red) if display;
  end

  def self.rm(path, display = false)
    puts "#{ARROW} rm -rf #{path}" if display;
    Dir.glob path do |file_path|
      FileUtils.rm_rf file_path;
    end
  rescue
    puts "Could not remove #{path}".colorize(:light_red) if display;
  end

  def self.cp(src_dir, dest_dir, display = false)
    puts "#{ARROW} cp -r #{src_dir} #{dest_dir}" if display;
    Dir.glob src_dir do |file_path|
      FileUtils.cp_r file_path, dest_dir;
    end
  rescue
    puts "Could not copy #{src_dir} to #{dest_dir}".colorize(:light_red) if display;
  end

  def self.mv(src_path, dest_path, display = false)
    puts "#{ARROW} mv #{src_path} #{dest_path}" if display;
    Dir.glob src_path do |file_path|
      FileUtils.mv file_path, File.join(dest_path, File.basename(file_path));
    end
  rescue
    puts "Could not move #{src_path} to #{dest_path}".colorize(:light_red) if display;
  end

  def self.mkdir(path, display = false)
    unless Dir.exists? path
      puts "#{ARROW} mkdir #{path}" if display;
    end
    FileUtils.mkdir_p path;
  rescue
    puts "Could not create directory: #{path}";
  end
end
