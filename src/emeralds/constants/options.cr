module Emeralds
  def self.opt
    {
      "app" => {
        "deps" => "#{FileHandler.find(File.join("libs", "**", "*.a")).join(' ')}",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).join(' ')}",
        "output" => "#{File.join("export", Emfile.instance.name)}",
      },
      "lib" => {
        "deps" => "",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).tap { |arr| arr.delete(File.join("src", "#{Emfile.instance.name}.c")); }.join(' ')}",
        "output" => "#{Emfile.instance.name}.a",
      },
      "test" => {
        "deps" => "#{FileHandler.find(File.join("libs", "**", "*.a.test")).join(' ')}",
        "input" => "#{FileHandler.find(File.join("src", "**", "*.c")).tap { |arr| arr.delete(File.join("src", "#{Emfile.instance.name}.c")); }.join(' ')} #{FileHandler.find(File.join("spec", "**", "*.spec.c")).join(' ')}",
        "output" => "#{File.join("spec", "spec_results")}",
      },
    };
  end
end
