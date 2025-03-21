class Emeralds::List < Emeralds::Command
  private def list(deps)
    if deps
      deps.sanitize.each do |key, value|
        puts "  #{COG} #{key}";
      end
    end
  end

  def message
    "Emeralds - Em libraries used:";
  end

  def block
    -> {
      deps = Emfile.instance.dependencies;
      list deps;
      dev_deps = Emfile.instance.dev_dependencies;
      list dev_deps;

      no_deps = (deps.try(&.size) || 0) + (dev_deps.try(&.size) || 0);
      if no_deps == 1
        puts "\n#{ARROW} #{no_deps} dependency";
      else
        puts "\n#{ARROW} #{no_deps} dependencies";
      end
    };
  end
end
