require "yaml";
require "colorize";
require "file_utils";

require "./emeralds/extensions/Command+install";
require "./emeralds/extensions/Command+move_copy";
require "./emeralds/extensions/Command+try_override_command";
require "./emeralds/extensions/Command+usage";

require "./emeralds/commands/Command";
require "./emeralds/commands/BuildAppDebug";
require "./emeralds/commands/BuildAppRelease";
require "./emeralds/commands/BuildLibDebug";
require "./emeralds/commands/BuildLibRelease";
require "./emeralds/commands/Clean";
require "./emeralds/commands/GenerateMakefile";
require "./emeralds/commands/Help";
require "./emeralds/commands/Init";
require "./emeralds/commands/InstallDev";
require "./emeralds/commands/Install";
require "./emeralds/commands/List";
require "./emeralds/commands/LocDeps";
require "./emeralds/commands/Loc";
require "./emeralds/commands/Run";
require "./emeralds/commands/Test";
require "./emeralds/commands/Version";

require "./emeralds/constants/cli";
require "./emeralds/constants/options";
require "./emeralds/constants/version";

require "./emeralds/modules/YamlReader";

require "./emeralds/main";

Emeralds::Main.run;
