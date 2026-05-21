# Emeralds

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![GPLv3 License](https://img.shields.io/badge/license-GPL%20v3-yellow.svg)](./LICENSE)

[![CI](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3ACI)

A module/package manager for C applications.

## Installation

**Run the install script**

```
chmod 755 install.sh
./install.sh
```

**On windows**

```
.\install-win32.bat
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
    remove [<name>]                     - Remove a .c/.h file pair
    build [app | lib] [debug | release] - Build the application in the `export` directory.
    run                                 - Run the compiled application.
    clean                               - Run the clean script
    help                                - Print this help message.
    init [<name>]                       - Initialize a new library with an em.json file.
    install [ | dev | all]              - Install dependencies into a flattened libs directory.
    reinstall                           - Reinstall dependencies into a flattened libs directory.
    uninstall [<name>]                  - Remove a dependency from em.json and libs.
    list                                - List dependencies and project modules.
    makefile                            - Generate a makefile for independent compilation
    loc                                 - Count the significant lines of code in the project
    lint                                - Lint all project sources with clang-format.
    test                                - Run the script of tests.
    version                             - Print the current version of the emerald.
    license                             - Update the license notice based on the em.json value.
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

**Add a new module, a `.c`/`.h` pair plus its test spec:**

```
em add one
```

```
Emeralds - Adding new .c/.h pair...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ one
  ➔ one.c
  ➔ one.h
  ➔ one.module.spec.h
  ➔ YourApp.spec.c
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.001 seconds
```

This creates `src/one/one.c`, `src/one/one.h`, and `spec/one/one.module.spec.h`, then wires the module into `spec/YourApp.spec.c` by adding its `#include` and a `T_one();` call to `cspec_run_suite`.

**Remove a module, deleting its source, header, and spec:**

```
em remove one
```

```
Emeralds - Removing .c/.h pair...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ one
  ➔ one.c
  ➔ one.h
  ➔ one.module.spec.h
  ➔ YourApp.spec.c
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.001 seconds
```

This deletes `src/one/` and `spec/one/`, then strips the module's `#include` and `T_one();` call from `spec/YourApp.spec.c`.

**Manage dependencies, navigate into your project and list dependencies:**

```
cd YourApp
em list
```

```
Emeralds - Em libraries used:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dependencies:
  ⚙ cSpec

Modules:
  ⚙ get_value

➔ 1 dependency
➔ 1 module
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

**Uninstall a dependency:**

```
em uninstall cSpec
```

```
Emeralds - Uninstalling dependency...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚙ Removed `cSpec` from em.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.001 seconds
```

This removes the named entry from both `dependencies` and `dev-dependencies` in `em.json` and deletes the corresponding `libs/<name>` directory.

**Edit configuration json file:**

```
cat em.json
```

```
{
  "name": "YourApp",
  "version": "0.0.1",
  "license": "mit",
  "locignore": {
    "extensions": [],
    "directories": []
  },
  "lintignore": {
    "extensions": [],
    "directories": []
  },
  "scripts": {},
  "compile-flags": {
    "darwin": {
      "cc": "clang",
      "debug": {
        "opt": "-O2",
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
    "linux": {
      "cc": "gcc",
      "debug": {
        "opt": "-Og",
        "version": "-std=c89",
        "flags": "-g",
        "warnings": "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic"
      },
      "release": {
        "opt": "-O3",
        "version": "",
        "flags": "",
        "warnings": ""
      }
    },
    "win32": {
      "cc": "gcc",
      "debug": {
        "opt": "-O2",
        "version": "-std=c89",
        "flags": "-g",
        "warnings": "-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic"
      },
      "release": {
        "opt": "-O2",
        "version": "-std=c89",
        "flags": "",
        "warnings": ""
      }
    }
  },
  "dependencies": {},
  "dev-dependencies": {
    "cSpec": "Oblivious-Oblivious/cSpec"
  }
}
```

- **name**: The name of your application or library.
- **version**: The version number displayed with `em version`.
- **license**: The project's license. This should be a valid SPDX license identifier.
  - Available license types: `mit`, `gpl-v2`, `apache-v2`, `gpl-v3`, `lgpl-v3`, `mpl-v2`, `epl-v2`, `agpl-v3`, `cc0-v1`, `cc0-v4`
- **scripts**: Custom commands runnable with `em <script>`. Script names can override built-in commands. Values can be a string command or an array of command lines.
- **locignore**: Extensions and project-relative directories ignored by `em loc`.
- **lintignore**: Extensions and project-relative directories ignored by `em lint`.

```
"scripts": {
  "build": [
    "mkdir -p export",
    "clang -O2 -o export/YourApp src/YourApp.c"
  ]
}
```

- **compile-flags**: The set of compiler flags.
  - Platform keys can use Crystal-supported operating system flags (e.g., `win32`, `linux`, `darwin`, `unix`).
  - **cc**: The C compiler to use for that platform.
  - **debug**: Debug build flags for that platform.
  - **release**: Release build flags for that platform.
    - **opt**: Optimization level (e.g., -Og, -O0).
    - **version**: The C standard to use (e.g., -std=c89, -std=c11).
    - **flags**: Additional compiler flags (e.g., -g -fsanitize=address).
    - **warnings**: Warning flags to enable (e.g., -Wall -Wextra).
- **dependencies**: A table of dependencies required for the project to run. The value grabs any Emeralds-compatible repository on GitHub (_user/repo_).
- **dev-dependencies**: A table of development dependencies **not** linked with the release version.

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

**Lint the project sources:**

```
em lint
```

```
Emeralds - Linting sources...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
➔ spec/YourApp.spec.c
➔ spec/get_value/get_value.module.spec.h
➔ src/YourApp.c
➔ src/get_value/get_value.c
➔ src/get_value/get_value.h
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.012 seconds
```

This runs `clang-format` on every file found from the project root, using the `.clang-format` generated by `em init`.

## Contributing

1. Fork it (<https://github.com/Oblivious-Oblivious/Emeralds/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [atha](https://github.com/Oblivious-Oblivious) - creator and maintainer
