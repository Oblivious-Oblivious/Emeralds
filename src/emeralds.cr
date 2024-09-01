# A package manager for C applications.
# Copyright (C) 2024 oblivious

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
require "./emeralds/commands/License";
require "./emeralds/commands/List";
require "./emeralds/commands/Loc";
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
