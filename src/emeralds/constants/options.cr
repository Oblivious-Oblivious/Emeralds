module Emeralds
  def self.opt
    {
      "app" => {
        "deps" => "#{FileHandler.find(File.join("libs", "**", "*.o")).join(' ')}",
        "input" => "#{FileHandler.find_multiple([
          File.join("src", "**", "*.c"),
          File.join("src", "**", "*.a"),
        ]).join(' ')}",
        "output" => "#{File.join("export", Emfile.instance.name)}",
      },
      "lib" => {
        "deps" => "",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).tap { |arr| arr.delete(File.join("src", "#{Emfile.instance.name}.c")); }.join(' ')}",
        "output" => "",
      },
      "test" => {
        "deps" => "#{FileHandler.find_multiple([
          File.join("export", "**", "*.o"),
          File.join("export", "**", "*.a"),
          File.join("libs", "**", "*.o"),
        ]).join(' ')}",
        "input" => "#{FileHandler.find(File.join("spec", "**", "*.spec.c")).join(' ')}",
        "output" => "#{File.join("spec", "spec_results")}",
      },
    };
  end
end
