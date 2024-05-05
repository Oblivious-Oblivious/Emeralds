require "json";
require "colorize";
require "file_utils";
require "http/client";
require "git-repository";

require "./emeralds/extensions/Hash+sanitize";

require "./emeralds/commands/Command";
require "./emeralds/commands/Add";
require "./emeralds/commands/BuildAppDebug";
require "./emeralds/commands/BuildAppRelease";
require "./emeralds/commands/BuildLibDebug";
require "./emeralds/commands/BuildLibRelease";
require "./emeralds/commands/Clean";
require "./emeralds/commands/GenerateMakefile";
require "./emeralds/commands/Help";
require "./emeralds/commands/Init";
require "./emeralds/commands/Install";
require "./emeralds/commands/InstallAll";
require "./emeralds/commands/InstallDev";
require "./emeralds/commands/List";
require "./emeralds/commands/Loc";
require "./emeralds/commands/LocAll";
require "./emeralds/commands/LocDeps";
require "./emeralds/commands/Run";
require "./emeralds/commands/Test";
require "./emeralds/commands/Version";

require "./emeralds/constants/cli";
require "./emeralds/constants/options";
require "./emeralds/constants/version";

require "./emeralds/emfile/BuildConfig";
require "./emeralds/emfile/CompileFlags";
require "./emeralds/emfile/Emfile";

require "./emeralds/modules/FileHandler";
require "./emeralds/modules/TerminalHandler";

require "./emeralds/main";

Emeralds::Main.run;
