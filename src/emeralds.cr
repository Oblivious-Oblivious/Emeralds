# A package manager for C applications.
#
# Copyright (C) 2020-2025 oblivious
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "json";
require "file_utils";
require "http/client";
require "git-repository";

require "./emeralds/extensions/Hash+sanitize";
require "./emeralds/extensions/String+colorize";

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
