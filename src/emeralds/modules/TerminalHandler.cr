# TODO - Replace of file operations with FileUtils
# TODO - Move all file operations to TerminalHandler and slowly make cross-platform

module Emeralds::TerminalHandler
  def self.generic_cmd(cmd, display = false)
    puts "#{ARROW} #{cmd}" if display;
    `#{cmd}`;
  rescue
    puts "#{cmd}: command not found".colorize(:light_red) if display;
  end

  def self.rm(path, display = false)
    puts "#{ARROW} rm -rf #{path}" if display;
    FileUtils.rm_rf path;
  rescue
    puts "Could not remove #{path}".colorize(:light_red) if display;
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
