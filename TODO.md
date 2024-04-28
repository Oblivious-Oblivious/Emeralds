## (✗) ver. 0.6.0
-----------------
  🟥 Allow for custom cflags inside of emfile.
  🟥 Validate that `add` and `init` options are valid string names (regex)
  🟥 Fix colorize methods that clash (white bold does not apply when it follows another color)

## (✗) ver. 0.5.0
-----------------
  🟩 On `em add newfile` we should also generate tests.
  🟩 Migrate into a `.c/.h` pair architecture so when initting, we `em add get_value` to return hello world.
  🟩 Fix test code to include test file directly.  When testing file.h we should directly include in file.spec.c/h along with cSpec.
  🟩 Remove all direct `cmd` commands and replace with cross platform crystal ones. (wget, git)
  🟩 Make sure em/emeralds runs only when em.yml file exists.
  🟩 Add an `em loc all` command.

## (✓) ver. 0.4.0
-----------------
  🟩 Add an `em run` command to run the executable in export
