module Emeralds
  OPT = {
    "name"            => "#{Emeralds::YamlReader.get_field "name"}",
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
    "deps"            => "find ./export -name \"*.*o\" 2>&1 | grep -v \"No such file or directory\"",
    "inputfiles"      => "find src/#{Emeralds::YamlReader.get_field "name"}/*.c 2>&1 | grep -v \"No such file or directory\"",
    "input"           => "find src/#{Emeralds::YamlReader.get_field "name"}.c 2>&1 | grep -v \"No such file or directory\"",
    "output"          => "#{Emeralds::YamlReader.get_field "name"}",
    "testinput"       => "find spec/#{Emeralds::YamlReader.get_field "name"}.spec.c 2>&1 | grep -v \"No such file or directory\"",
    "testoutput"      => "spec_results",
  }; # TODO - Make cross platform, convert bash searches to crystal glob serches for writing makefile fields
end
