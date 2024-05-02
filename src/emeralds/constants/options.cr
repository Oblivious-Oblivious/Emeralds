module Emeralds
  def self.opt
    {
      "name"            => "#{YamlReader.get_field "name"}",
      "cc"              => "clang",
      "debug_opt"       => "-Og -g",
      "debug_version"   => "-std=c89",
      "debug_flags"     => "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic",
      "debug_warnings"  => "-Wno-int-conversion -Wno-incompatible-pointer-types",
      "release_opt"     => "-O2",
      "release_version" => "-std=c2x",
      "release_flags"   => "",
      "release_warnings" => "-Wno-int-conversion",
      "unused_warnings" => "-Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi",
      "test_warnings"   => "-Wno-int-conversion -Wno-implicit-function-declaration -Wno-incompatible-pointer-types",
      "libs"            => "-c",
      "deps"            => "#{FileHandler.find_with_pattern(File.join("export", "**", "*.o")).join(' ')} #{FileHandler.find_with_pattern(File.join("libs", "**", "*.o")).join(' ')}",
      "inputfiles"      => "#{FileHandler.find(File.join("src", "**", "*.c")).tap { |arr| arr.delete(File.join("src", "#{YamlReader.get_field("name")}.c")); }.join(' ')}",
      "input"           => "#{FileHandler.find(File.join("src", "**", "*.c")).join(' ')}",
      "output"          => "#{File.join("export", YamlReader.get_field("name"))}",
      "testinput"       => "#{FileHandler.find(File.join("spec", "**", "*.spec.c")).join(' ')}",
      "testoutput"      => "#{File.join("spec", "spec_results")}",
    };
  end
end
