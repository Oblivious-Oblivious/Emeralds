class Emeralds::List < Emeralds::Command
  def message
    "Emeralds - Em libraries used:";
  end

  # Get the list of dependencies from the yaml file in a vector
  def block
    -> {
      deps = YamlReader.get_dependencies;
      deps.each do |dep|
        YamlReader.list_dep dep if dep != "";
      end

      dev_deps = YamlReader.get_dev_dependencies;
      dev_deps.each do |dep|
        YamlReader.list_dep dep if dep != "";
      end

      no_deps = deps.size + dev_deps.size;
      if no_deps == 1
        puts "\n#{Emeralds.arrow} #{no_deps} dependency";
      else
        puts "\n#{Emeralds.arrow} #{no_deps} dependencies";
      end
    };
  end
end
