module Emeralds
  def self.sources_app
    "#{FileHandler.find(File.join("src", "*", "**", "*.c")).join(' ')} #{FileHandler.find(File.join("src", "*", "**", "*.a")).join(' ')}";
  end

  def self.sources_lib
    "#{FileHandler.find(File.join("src", "*", "**", "*.c")).join(' ')}";
  end

  def self.deps_release
    "#{FileHandler.find(File.join("libs", "*", "export", "*.a")).join(' ')}";
  end

  def self.deps_test
    "#{FileHandler.find(File.join("libs", "*", "export", "*.a.test")).join(' ')}";
  end

  def self.input_app
    "#{FileHandler.find(File.join("src", "*.c")).join(' ')}";
  end

  def self.input_test
    "#{FileHandler.find(File.join("spec", "*.spec.c")).join(' ')}";
  end

  def self.output_app
    "#{File.join("export", Emfile.instance.name)}";
  end

  def self.output_lib
    "#{Emfile.instance.name}.a";
  end

  def self.output_test
    "#{File.join("spec", "spec_results")}";
  end
end
