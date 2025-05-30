## (✗) ver. 1.0.0
-----------------
  🟥 Add a file watcher for a possible recompilation
  🟥 Add incremental/individual compilation of files like make.
  🟥 Rework makefile to be simpler and to align with em commands.
  🟥 Add a logger mode where all commands results are explicitely displayed.
  🟥 Add translation for status codes to actual errors in em run (11 for segfault and so on)

## (✗) ver. 0.11.0
  🟥 Handle missing json values that are string interpolated (like compile-flag).
     Potentially add default flags if missing.
  🟥 Add windows/linux/macos versions of cc compiler commands.
     There are cases where different sanitizers only work on linux.
     Probably add extra options in the emfile.

## (✗) ver. 0.10.0
------------------
  🟩 Remove all comments.
  🟥 Remove all generic commands (and backtic commands) with cross-platform equivalents.
  🟥 Add `em delete` command removing `src/<item>` and `spec/<item>`
  🟩 Maybe add an option for only installing missing dependencies.
     Add a command option for libraries reinstall.
     When `em install` we only get missing ones.
     When `em reinstall` we reinstall libraries.
  🟩 Fix errors/crashes on Emfile based on keys that might be missing. (e.g. compile-flags missing).

## (✓) ver. 0.9.0
-----------------
  🟩 Make sure all libraries in -c compile to *.o.
  🟩 Revamp colors for text to be white bold and make sure error and success are colored properly.
  🟩 Refactor build script to work with compiler tools only instead of `ar`.
  🟩 Fixed warning when was trying to link .a files when building more static libraries.
  🟩 Fixed bug where I was rebuild export directory (only em clean can remove this).
  🟩 Add an automation that converts *nix paths (./dir/file) to File.join calls by splitting on '/'.
  🟩 Handle json load errors.
    Failed to load or parse em.json: Unexpected token: } at line 21, column 5
    parsing Emeralds::BuildConfig#warnings at line 20, column 7
    parsing Emeralds::CompileFlags#debug at line 16, column 5
    parsing Emeralds::Emfile#compile-flags at line 14, column 3

## (✓) ver. 0.8.0
-----------------
  🟩 Allow for custom cflags inside of emfile.
  🟩 Make sure `em run` correctly outputs all results in stdout, stderr and stdin.
     Otherwise just remove the command.
  🟩 Do not include `.o` files from dev-dependencies, only link normal deps (get from json list).
  🟩 Use `.a` static libraries one for specs and one for release.
  🟩 In wget_a_gplv3_license, read license field in emfile and wget accordingly.
  🟩 Abstract compilation command with option selection in custom function.
  🟩 Add a CONTRIBUTING.md, CHANGELOG.md.
  🟩 Made build process more robust using different C versions and flags, and standardizing to json.

## (✓) ver. 0.7.0
-----------------
  🟩 Do not create new emerald when name already exists.
  🟩 Do not em test when cSpec does not exist (throw error if libs/cSpec empty).
  🟩 Validate that `add` and `init` options are valid string names (regex).
  🟩 Fix colorize methods that clash (white bold does not apply when it follows another color).
  🟩 In em loc, add a percentage that signifies how much is test code and source code accordingly.
  🟩 Replace all direct paths with File.join.
  🟩 Fix compilation error on generic_cmd.
  🟩 Fix YamlReader case where key is not found.

## (✓) ver. 0.6.0
-----------------
  🟩 On `em add newfile` we should also generate tests.
  🟩 Migrate into a `.c/.h` pair architecture so when initting, we `em add get_value` to return hello world.
  🟩 Fix test code to include test file directly.  When testing file.h we should directly include in file.spec.c/h along with cSpec.
  🟩 Remove all direct `cmd` commands and replace with cross platform crystal ones. (wget, git).
  🟩 Make sure em/emeralds runs only when em.yml file exists.
  🟩 Add an `em loc all` command.

## (✓) ver. 0.5.0
-----------------
  🟩 Add an `em run` command to run the executable in export.
