require "spec";
require "../src/emeralds.libs";

require "./emeralds/extensions/Hash+sanitize.spec";

require "./emeralds/commands/Add.spec";
require "./emeralds/commands/BuildAppDebug.spec";
require "./emeralds/commands/BuildAppRelease.spec";
require "./emeralds/commands/BuildLibDebug.spec";
require "./emeralds/commands/BuildLibRelease.spec";
require "./emeralds/commands/Clean.spec";
require "./emeralds/commands/Command.spec";
require "./emeralds/commands/GenerateMakefile.spec";
require "./emeralds/commands/Help.spec";
require "./emeralds/commands/Init.spec";
require "./emeralds/commands/Install.spec";
require "./emeralds/commands/InstallAll.spec";
require "./emeralds/commands/InstallDev.spec";
require "./emeralds/commands/License.spec";
require "./emeralds/commands/List.spec";
require "./emeralds/commands/Loc.spec";
require "./emeralds/commands/Reinstall.spec";
require "./emeralds/commands/Run.spec";
require "./emeralds/commands/Test.spec";
require "./emeralds/commands/Version.spec";

require "./emeralds/constants/cli.spec";
require "./emeralds/constants/languages.spec";
require "./emeralds/constants/version.spec";

require "./emeralds/emfile/BuildConfig.spec";
require "./emeralds/emfile/CompileFlags.spec";
require "./emeralds/emfile/LocIgnore.spec";
require "./emeralds/emfile/emfile.spec";

require "./emeralds/modules/Terminal.spec";

require "./emeralds/main.spec";
