module Emeralds
  OPT = {
    "name"            => "#{Emeralds::YamlHelper.get_field "name"}",
    "cc"              => "clang",
    "debug_opt"       => "-Og -g",
    "debug_version"   => "-std=c89",
    "debug_flags"     => "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic",
    "release_opt"     => "-O2",
    "release_version" => "-std=c2x",
    "release_flags"   => "",
    "warnings"        => "-Wno-incompatible-pointer-types",
    "unused_warnings" => "-Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi",
    "remove_warnings" => "-Wno-int-conversion",
    "test_warnings"   => "-Wno-implicit-function-declaration -Wno-incompatible-pointer-types",
    "libs"            => "-c",
    "deps"            => "$(find ./export -name \"*.*o\" 2>&1 | grep -v \"No such file or directory\")",
    "inputfiles"      => "$(find src/#{Emeralds::YamlHelper.get_field "name"}/*.c 2>&1 | grep -v \"No such file or directory\")",
    "input"           => "$(find src/#{Emeralds::YamlHelper.get_field "name"}.c 2>&1 | grep -v \"No such file or directory\")",
    "output"          => "#{Emeralds::YamlHelper.get_field "name"}",
    "testinput"       => "$(find spec/#{Emeralds::YamlHelper.get_field "name"}.spec.c 2>&1 | grep -v \"No such file or directory\")",
    "testoutput"      => "spec_results",
  }; # TODO Make cross platform
end
