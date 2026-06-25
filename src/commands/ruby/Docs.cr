class Emeralds::Ruby::Docs < Emeralds::Docs
  def block
    -> {
      files = Dir
        .glob(File.join("src", "**", "*.rb"))
        .map(&.posix_path)
        .sort!;

      if files.empty?
        puts "#{ARROW} No source files found".colorize(:red);
      else
        Terminal.generic_cmd "yard doc #{files.shell_join}", display: true;
      end
    };
  end
end
