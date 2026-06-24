class Emeralds::C::Docs < Emeralds::Docs
  private def sources
    Dir
      .glob([File.join("src", "**", "*.c"), File.join("src", "**", "*.h")])
      .map(&.posix_path)
      .sort!;
  end

  def block
    -> {
      files = sources;
      if files.empty?
        puts "#{ARROW} No source files found".colorize(:red);
      elsif Process.find_executable("clang-doc").nil?
        puts "#{ARROW} clang-doc not found".colorize(:red);
      else
        includes = C::Build.new.deps_includes;
        Terminal.generic_cmd "clang-doc --output=docs --format=html " \
                             "#{files.shell_join} -- -x c -std=c23 #{includes}",
          display: true;
      end
    };
  end
end
