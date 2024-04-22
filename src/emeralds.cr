require "yaml";
require "colorize";
require "file_utils";

require "./emeralds/commands/command";
require "./emeralds/commands/build_debug";
require "./emeralds/commands/build_library_debug";
require "./emeralds/commands/build_library_release";
require "./emeralds/commands/build_release";
require "./emeralds/commands/clean";
require "./emeralds/commands/generate_makefile";
require "./emeralds/commands/help";
require "./emeralds/commands/init";
require "./emeralds/commands/install_dev";
require "./emeralds/commands/install";
require "./emeralds/commands/list";
require "./emeralds/commands/loc_deps";
require "./emeralds/commands/loc";
require "./emeralds/commands/test";
require "./emeralds/commands/version";

require "./emeralds/constants/cli";
require "./emeralds/constants/options";
require "./emeralds/constants/version";

require "./emeralds/modules/compiler_options_helper";
require "./emeralds/modules/yaml_helper";

require "./emeralds/command_processor";
require "./emeralds/main";

Emeralds::Main.run;
