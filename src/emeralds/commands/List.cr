class Emeralds::List < Emeralds::Command
  def message
    "Emeralds - Em libraries used:";
  end

  # Get the list of dependencies from the yaml file in a vector
  def block
    -> {
      deps = Emfile.instance.dependencies;
      Emfile.list deps;
      dev_deps = Emfile.instance.dev_dependencies;
      Emfile.list dev_deps;

      no_deps = deps.size + dev_deps.size;
      if no_deps == 1
        puts "\n#{Emeralds.arrow} #{no_deps} dependency";
      else
        puts "\n#{Emeralds.arrow} #{no_deps} dependencies";
      end
    };
  end
end
