# Emeralds

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![GPLv3 License](https://img.shields.io/badge/license-GPL%20v3-yellow.svg)](./LICENSE)

[![CI](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3ACI)

A module/package manager for C applications.

## Installation

**Run the install script**

```
shards install
./install
```

## Usage

```
em help
```

```
Emeralds - Help/Usage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
emeralds/em [<command>]

Commands:
    add [<name>]                        - Add a new .c/.h file pair
    build [app | lib] [debug | release] - Build the application in the `export` directory.
    run                                 - Run the compiled application.
    clean                               - Run the clean script
    help                                - Print this help message.
    init [<name>]                       - Initialize a new library with an em.json file.
    install [ | dev | all]              - Install dependencies recursively for each included library.
    reinstall                           - Reinstall dependencies recursively for each included library.
    list                                - List dependencies in the em file.
    makefile                            - Generate a makefile for independent compilation
    loc                                 - Count the significant lines of code in the project
    test                                - Run the script of tests.
    version                             - Print the current version of the emerald.
    license                             - Update the license notice based on the em.yml value.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**To start a new project:**

```
em init YourApp
```

```
Emeralds - Initializing a new project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙ Creating directory: YourApp
⚙ Writing initial files:
  ➔ em.json
  ➔ .git
  ➔ spec
    ➔ get_value
      ➔ get_value.module.spec.h
    ➔ YourApp.spec.c
  ➔ src
    ➔ get_value
      ➔ get_value.c
      ➔ get_value.h
    ➔ YourApp.c
  ➔ .clangd
  ➔ .clang-format
  ➔ .gitignore
  ➔ LICENSE
  ➔ README.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.697 seconds
```

**Manage dependencies, navigate into your project and list dependencies:**

```
cd YourApp
em list
```

```
Emeralds - Em libraries used:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚙ cSpec

➔ 1 dependency
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.001 seconds
```

**Install dependencies:**

```
em install all
```

```
Emeralds - Resolving all dependencies...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚙ Installing `cSpec`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 3.822 seconds
```

**Edit configuration json file:**

```
cat em.json
```

```
{
  "name": "YourApp",

  "version": "0.1.0",

  "dependencies": {},

  "dev-dependencies": {
    "cSpec": "Oblivious-Oblivious/cSpec"
  },

  "build": "",

  "compile-flags": {
    "cc": "clang",
    "debug": {
      "opt": "-Og",
      "version": "-std=c89",
      "flags": "-g -fsanitize=address",
      "warnings": "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic"
    },
    "release": {
      "opt": "-O2",
      "version": "-std=c89",
      "flags": "",
      "warnings": ""
    }
  },

  "license": "mit"
}
```

- **name**: The name of your application or library.
- **version**: The version number displayed with `em version`.
- **dependencies**: A table of dependencies required for the project to run. The value grabs any Emeralds-compatible repository on GitHub (_user/repo_).
- **dev-dependencies**: A table of development dependencies **not** linked with the release version.
- **build**: A custom build scrip/command that overrides normal building and execution.
- **compile-flags**: The set of compiler flags.
  - **cc**: The C compiler to use (e.g., clang, gcc).
  - **debug**: Debug build flags.
  - **release**: Release build flags.
    - **opt**: Optimization level (e.g., -Og, -O0).
    - **version**: The C standard to use (e.g., -std=c89, -std=c11).
    - **flags**: Additional compiler flags (e.g., -g -fsanitize=address).
    - **warnings**: Warning flags to enable (e.g., -Wall -Wextra).
- **license**: The project's license. This should be a valid SPDX license identifier.
  - Available license types: `mit`, `gpl-v2`, `apache-v2`, `gpl-v3`, `lgpl-v3`, `mpl-v2`, `epl-v2`, `agpl-v3`, `cc0-v1`, `cc0-v4`

**Testing your application and run the test suite:**

```
em test
```

```
Emeralds - Running tests...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ rm -rf spec/spec_results
➔ clang -Og -std=c2x -g -fsanitize=address -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic -o spec/spec_results  src/get_value/get_value.c spec/YourApp.spec.c

➔ ./spec/spec_results
/######## ########/
/##### cSpec #####/
/######## ########/

Module `T_get_value`
    `#get_value`
        ✓ it returns `Hello, World!`

● 1 tests
✓ 1 passing
✗ 0 failing
- 0 skipped
★ Finished in 0.00487 ms
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 4.039 seconds
```

**Build your application:**

```
em build app release
```

```
Emeralds - Compiling as an app...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ clang -O2 -std=c89   -o export/YourApp  src/get_value/get_value.c src/YourApp.c
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.424 seconds
```

**Run the executable:**

```
./export/YourApp

Hello, World!
```

**Clean up project build artifacts:**

```
em clean
```

```
Emeralds - Cleaning the library files...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ rm -rf spec/spec_results
➔ rm -rf export
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.003 seconds
```

## Contributing

1. Fork it (<https://github.com/Oblivious-Oblivious/Emeralds/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [oblivious](https://github.com/Oblivious-Oblivious) - creator and maintainer
