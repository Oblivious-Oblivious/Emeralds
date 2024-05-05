module Emeralds
  def self.opt
    {
      "app" => {
        "deps" => "",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).join(' ')}",
        "output" => "#{File.join("export", Emfile.instance.name)}",
      },
      "lib" => {
        "deps" => "",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).tap { |arr| arr.delete(File.join("src", "#{Emfile.instance.name}.c")); }.join(' ')}",
        "output" => "",
      },
      "test" => {
        "deps" => "#{FileHandler.find_with_pattern(File.join("export", "**", "*.o")).join(' ')} #{FileHandler.find_with_pattern(File.join("libs", "**", "*.o")).join(' ')}",
        "input" => "#{FileHandler.find(File.join("spec", "**", "*.spec.c")).join(' ')}",
        "output" => "#{File.join("spec", "spec_results")}",
      },
    };
  end
end
