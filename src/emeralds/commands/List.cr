class Emeralds::List < Emeralds::Command
  # List a dependency as formatted text
  #
  # dep -> The name of the dependecy to list
  private def list_dep(dep)
    parts = Emeralds::CommandProcessor.get_parts from: dep;
    puts "  #{COG} #{parts[0]}";
  end

  def message
    "Emeralds - Em libraries used:";
  end

  # Get the list of dependencies from the yaml file in a vector
  def block
    -> {
      deps = Emeralds::YamlHelper.get_dependencies;
      deps.each do |dep|
        list_dep dep if dep != "";
      end

      dev_deps = Emeralds::YamlHelper.get_dev_dependencies;
      dev_deps.each do |dep|
        list_dep dep if dep != "";
      end

      no_deps = deps.size + dev_deps.size;
      if no_deps == 1
        puts "\n#{no_deps} dependency";
      else
        puts "\n#{no_deps} dependencies";
      end
    };
  end
end
