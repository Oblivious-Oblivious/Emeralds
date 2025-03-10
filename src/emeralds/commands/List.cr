class Emeralds::List < Emeralds::Command
  # List a list of dependencies from the emfile.
  private def list(deps)
    deps.sanitize.each do |key, value|
      puts "  #{COG} #{key}";
    end
  end

  def message
    "Emeralds - Em libraries used:";
  end

  # Get the list of dependencies from the yaml file in a vector
  def block
    -> {
      deps = Emfile.instance.dependencies;
      list deps;
      dev_deps = Emfile.instance.dev_dependencies;
      list dev_deps;

      no_deps = deps.size + dev_deps.size;
      if no_deps == 1
        puts "\n#{ARROW} #{no_deps} dependency";
      else
        puts "\n#{ARROW} #{no_deps} dependencies";
      end
    };
  end
end
