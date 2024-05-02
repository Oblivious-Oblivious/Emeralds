## (✗) ver. 1.0.0
-----------------
  🟥 Make sure all libraries in -c compile to *.o

## (✗) ver. 0.7.0
-----------------
  🟥 Allow for custom cflags inside of emfile.
  🟥 Do not create new emerald when name already exists.
  🟥 Do not em test when cSpec does not exist (throw error if libs/cSpec empty).
  🟩 Validate that `add` and `init` options are valid string names (regex).
  🟩 Fix colorize methods that clash (white bold does not apply when it follows another color).
  🟥 In em loc, add a percentage that signifies how much is test code and source code accordingly.
  🟩 Replace all direct paths with File.join
  🟥 Fix compilation error on generic_cmd
    ⚙ Installing `Bool`
      clang: error: no input files
    ⚙ Installing `cSpec`
  🟥 Fix YamlReader case where key is not found (add custom errors based on key missing)
    Unhandled exception: Missing hash key: "build" (KeyError)

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
  🟩 Add an `em run` command to run the executable in export
