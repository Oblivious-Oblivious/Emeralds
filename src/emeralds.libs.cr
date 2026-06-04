require "colorize";
require "compress/zip";
require "file_utils";
require "http/client";
require "json";

require "./emeralds/extensions/Hash+sanitize";

require "./emeralds/commands/Command";
require "./emeralds/commands/Add";
require "./emeralds/commands/BuildAppDebug";
require "./emeralds/commands/BuildAppRelease";
require "./emeralds/commands/BuildAppDev";
require "./emeralds/commands/BuildAppStage";
require "./emeralds/commands/BuildAppPreprod";
require "./emeralds/commands/BuildAppProd";
require "./emeralds/commands/BuildLibDebug";
require "./emeralds/commands/BuildLibRelease";
require "./emeralds/commands/BuildLibDev";
require "./emeralds/commands/BuildLibStage";
require "./emeralds/commands/BuildLibPreprod";
require "./emeralds/commands/BuildLibProd";
require "./emeralds/commands/Clean";
require "./emeralds/commands/GenerateMakefile";
require "./emeralds/commands/Help";
require "./emeralds/commands/Init";
require "./emeralds/commands/Install";
require "./emeralds/commands/InstallAll";
require "./emeralds/commands/InstallDev";
require "./emeralds/commands/InstallGit";
require "./emeralds/commands/License";
require "./emeralds/commands/Lint";
require "./emeralds/commands/List";
require "./emeralds/commands/Loc";
require "./emeralds/commands/Reinstall"
require "./emeralds/commands/Remove";
require "./emeralds/commands/Uninstall";
require "./emeralds/commands/Run";
require "./emeralds/commands/Test";
require "./emeralds/commands/Update";
require "./emeralds/commands/Version";

require "./emeralds/constants/cli";
require "./emeralds/constants/languages";
require "./emeralds/constants/operating_systems";
require "./emeralds/constants/repository";
require "./emeralds/constants/version";

require "./emeralds/emfile/CompileFlags";
require "./emeralds/emfile/PlatformConfig";
require "./emeralds/emfile/Ignore";
require "./emeralds/emfile/Emfile";

require "./emeralds/modules/Terminal";

require "./emeralds/main";
