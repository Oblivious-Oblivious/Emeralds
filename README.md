# Emeralds

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![MIT License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)

A module/package manager for C applications.

## Installation

### Homebrew

```bash
brew install Oblivious-Oblivious/tap/emeralds
```

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/Oblivious-Oblivious/Emeralds/v0.14.2/scripts/get.sh | sh
```

### Windows with [scoop.sh](https://scoop.sh/).

```powershell
scoop install https://raw.githubusercontent.com/Oblivious-Oblivious/homebrew-tap/master/emeralds.json
```

### From source

Requires [Crystal](https://crystal-lang.org/) and Shards. Clone the repo first.

**\*nix**

```sh
rm -rf bin
shards build --release --no-debug
cp bin/emeralds bin/em
cp bin/em bin/emeralds /usr/local/bin/
```

**Windows**

```
if exist bin rmdir /s /q bin
shards.exe build --release --no-debug
copy /Y bin\emeralds.exe bin\em.exe
copy /Y bin\em.exe C:\msys64\ucrt64\bin\
copy /Y bin\emeralds.exe C:\msys64\ucrt64\bin\
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
    lint                                - Lint all project sources with clang-format.
    add [<name>]                             - Add a new .c/.h file pair
    remove [<name>]                          - Remove a .c/.h file pair
    build [app | lib] [profile]              - Build the project in the `export` directory.
                                                profiles: debug, release, dev, stage, preprod, prod.
    run                                      - Run the compiled application.
    clean                                    - Run the clean script
    help                                     - Print this help message.
    init [ | <name>] [--template] [--author] - Initialize a new project; runs an interactive setup when no name is given.
    install [ | <link> | dev | all]          - Install dependencies into a flattened libs directory.
    reinstall                                - Reinstall dependencies into a flattened libs directory.
    uninstall [<name>]                       - Remove a dependency from em.json and libs.
    list                                     - List dependencies and project modules.
    makefile                                 - Generate a makefile for independent compilation
    loc                                      - Count the significant lines of code in the project
    test                                     - Run the script of tests.
    version                                  - Print the current version of the emerald.
    update                                   - Update emeralds to the newest released version.
    license                                  - Update the license notice based on the em.json value.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**To start a new project:**

```
em init YourApp
```

Run `em init` with no name to start an interactive setup that prompts for the
project name, author, and template (defaults to `c`).

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
    ➔ YourApp.h
    ➔ YourApp.c
  ➔ .clangd
  ➔ .clang-format
  ➔ .gitignore
  ➔ LICENSE
  ➔ README.md
  ➔ AGENTS.md
  ➔ CLAUDE.md -> AGENTS.md
  ➔ .cursorrules -> AGENTS.md
  ➔ GEMINI.md -> AGENTS.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All done in 0.761 seconds
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
  ➔ one/one.h
  ➔ YourApp.h
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
  ➔ one/one.h
  ➔ YourApp.h
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

**Add and install a dependency from a git link:**

```
em install https://github.com/Oblivious-Oblivious/cSpec
```

This appends `"https://github.com/Oblivious-Oblivious/cSpec": "latest"` to `em.json`. You can pin versions by changing the value from `latest` to a release tag (such as `0.1.0`).

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
  "$schema": "https://raw.githubusercontent.com/Oblivious-Oblivious/Emeralds/master/schema/em.schema.json",
  "author": "",
  "name": "YourApp",
  "version": "0.0.1",
  "license": "mit",
  "locignore": {
    "extensions": [],
    "directories": ["libs"]
  },
  "lintignore": {
    "extensions": [],
    "directories": ["libs"]
  },
  "scripts": {},
  "compile-flags": {
    "darwin": {
      "debug": ["clang", "-O2", "-std=c89", "-g", "-fsanitize=address", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
      "release": ["clang", "-O2", "-std=c89"]
    },
    "linux": {
      "debug": ["gcc", "-O2", "-std=c89", "-g", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
      "release": ["gcc", "-O2", "-std=c89"]
    },
    "win32": {
      "debug": ["gcc", "-O2", "-std=c89", "-g", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
      "release": ["gcc", "-O2", "-std=c89"]
    }
  },
  "dependencies": {},
  "dev-dependencies": {
    "https://github.com/Oblivious-Oblivious/cSpec": "latest"
  }
}
```

- **author**: The name of the author/creator of the project.
- **name**: The name of your application or library.
- **version**: The version number displayed with `em version`.
- **license**: The project's license. This should be a valid SPDX license identifier.
  - Available license types: `mit`, `gpl-v2`, `apache-v2`, `gpl-v3`, `lgpl-v3`, `mpl-v2`, `epl-v2`, `agpl-v3`, `cc0-v1`, `cc0-v4`
- **scripts**: Custom commands runnable with `em <script>`. Script names can override built-in commands. Values can be a string command or an array of command lines.

```
"scripts": {
  "build": [
    "mkdir -p export",
    "clang -O2 -o export/YourApp src/YourApp.c"
  ]
}
```

- **locignore**: Extensions and project-relative directories ignored by `em loc`.
- **lintignore**: Extensions and project-relative directories ignored by `em lint`.
- **compile-flags**: The set of compiler flags.
  - Platform keys can use Crystal-supported operating system flags (e.g., `win32`, `linux`, `darwin`, `unix`).
  - **debug**: Debug build compiler options as separate array items.
  - **release**: Release build compiler options as separate array items.
  - **dev**: Development build compiler options as separate array items.
  - **stage**: Staging build compiler options as separate array items.
  - **preprod**: Pre-production build compiler options as separate array items.
  - **prod**: Production build compiler options as separate array items.
- **link**: Linker flags this package needs to build against (e.g. `["-lm", "-lcurl"]`). Promotes these on the compiler-flags on install.
- **dependencies**: A table of dependencies required for the project to run. The key is the full git link to a repository and the value is the version: `latest` for the master branch, or a release tag (`0.3.2`) to fetch that specific archive.
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
