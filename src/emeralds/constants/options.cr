module Emeralds
  def self.sources_app
    "#{FileHandler.find(File.join("src", "*", "**", "*.c")).join(' ')} #{FileHandler.find(File.join("src", "*", "**", "*.a")).join(' ')}".rstrip;
  end

  def self.sources_lib
    "#{FileHandler.find(File.join("src", "*", "**", "*.c")).join(' ')}".rstrip;
  end

  def self.sources_test
    "#{FileHandler.find(File.join("src", "*", "**", "*.c")).join(' ')} #{FileHandler.find(File.join("src", "*", "**", "*.a.test")).join(' ')}".rstrip;
  end

  def self.deps_release
    "#{FileHandler.find(File.join("libs", "*", "export", "*.a")).join(' ')}".rstrip;
  end

  def self.deps_test
    "#{FileHandler.find(File.join("libs", "*", "export", "*.a.test")).join(' ')}".rstrip;
  end

  def self.input_app
    "#{FileHandler.find(File.join("src", "*.c")).join(' ')}".rstrip;
  end

  def self.input_test
    "#{FileHandler.find(File.join("spec", "*.spec.c")).join(' ')}".rstrip;
  end

  def self.output_app
    "#{File.join("export", Emfile.instance.name)}".rstrip;
  end

  def self.output_lib
    "#{Emfile.instance.name}.a".rstrip;
  end

  def self.output_test
    "#{File.join("spec", "spec_results")}".rstrip;
  end
end
