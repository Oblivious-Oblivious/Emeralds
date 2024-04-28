module Emeralds
  OPT = {
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
    "deps"            => "#{FileHandler.find_with_pattern("./export", "*.o").join ' '}",
    "inputfiles"      => "#{FileHandler.find("src/**/*.c").tap { |arr| arr.delete("src/#{YamlReader.get_field "name"}.c"); }.join(' ')}",
    "input"           => "#{FileHandler.find("src/**/*.c").join ' '}",
    "output"          => "#{YamlReader.get_field "name"}",
    "testinput"       => "#{FileHandler.find("spec/**/*.spec.c").join ' '}",
    "testoutput"      => "spec_results",
  };
end
