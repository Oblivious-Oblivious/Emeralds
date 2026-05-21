class Emeralds::List < Emeralds::Command
  private def list(deps)
    if deps
      deps.sanitize.each do |key, value|
        puts "  #{COG} #{key}";
      end
    end
  end

  private def list_modules(directory, depth = 1)
    return unless Dir.exists? directory;

    Dir.children(directory).sort.each do |entry|
      path = File.join directory, entry;
      next unless File.directory? path;

      puts "#{"  " * depth}#{depth > 1 ? DOWN_ARROW : COG} #{entry}";
      list_modules path, depth + 1;
    end
  end

  def message
    "Emeralds - Em libraries used:";
  end

  def block
    -> {
      puts "Dependencies:";
      deps = Emfile.instance.dependencies;
      list deps;
      dev_deps = Emfile.instance.dev_dependencies;
      list dev_deps;
      puts;
      puts "Modules:";
      list_modules "src";

      puts;

      no_deps = (deps.try(&.size) || 0) + (dev_deps.try(&.size) || 0);
      if no_deps == 1
        puts "#{ARROW} #{no_deps} dependency";
      else
        puts "#{ARROW} #{no_deps} dependencies";
      end

      no_modules = Dir.children("src").count { |entry|
        File.directory? File.join("src", entry);
      };
      if no_modules == 1
        puts "#{ARROW} #{no_modules} module";
      else
        puts "#{ARROW} #{no_modules} modules";
      end
    };
  end
end
