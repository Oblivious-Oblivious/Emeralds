## (✗) ver. 0.5.0
-----------------
  🟥 On `em add newfile` we should also generate tests.
  🟥 Migrate into a `.c/.h` pair architecture so when initting, we `em add get_value` to return hello world.
  🟥 Fix test code to include test file directly.  When testing file.h we should directly include in file.spec.c/h along with cSpec.
  🟥 Remove all direct `cmd` commands and replace with cross platform crystal ones.
  🟥 Allow for custom cflags inside of emfile.
  🟥 Make sure em/emeralds runs only when em.yml file exists.

## (✗) ver. 0.4.0
-----------------
  🟩 Add an `em run` command to run the executable in export
