# Changes for Emeralds 0.8.0 (May 05 2024)

* Added a new `em license` command that fetches the license defined in the emfile.

# Changes for Emeralds 0.7.0 (May 03 2024)

* Fixed YamlReader case where key is not found
* Fixed compilation error when running gcc or clang without `.c` files.
* Replace all direct paths with cross platform `File.join`.
* Added a percentage in `em loc` that signifies how much is test code and source code.
* Validated that `add` and `init` options are valid string names.
* Handled command crashing errors like missing files or name collisions.

# Changes for Emeralds 0.6.0 (Apr 28 2024)

* Removed unused code.
* Avoided recursive includes by only keeping exported values on libs.
* Edited build scripts to run debug and release warnings respectively.
* Added new commands: em install all, em add, em loc all.
* Edited em init file architecture.
* Make sure em/emeralds runs only when em.yml file exists.
* Removed all direct `cmd` commands and replaced them with cross platform ones.

# Changes for Emeralds 0.5.0 (Apr 23 2024)

* Refactored codebase for easier management.
* Fixed makefile generation, now all find commands work properly.
* Added a new `run` command for running the compiled executable.
* Clean commands also remove dSYM files.

# Changes for Emeralds 0.4.0 (Apr 04 2021)

* Fixed display bugs on all operating systems.
* Implemented a cross platform compilation makefile.
* Added support for debug and release builds.
* Added support for counting lines of code in library emeralds.
* Moved documentation to individual classes rather than all together in a docs file.

# Changes for Emeralds 0.3.0 (Mar 04 2021)

* Fixed testing and CI for the project.
* Added compilation to static libraries.
* Added recursive installation of dependencies and code for each emerald.
* Added instructions for installation and usage.
* Added functionality for counting lines of code in the project.
* Added cSpec as a default dependency.
* Fixed directory bugs.

# Changes for Emeralds 0.2.0 (Feb 28 2021)

* Migrated the whole codebase to crystal-lang.

# Changes for Emeralds 0.1.0 (Jun 22 2020)

* Adds the first version of the package manager.
* Auto generates a .git repository with .gitignore declarations.
* Adds functionality for downloading dependencies from git.
* Has scripts for building as an executable or a shared library.
* Has test scripts and postinstall directives for recursive dependency management.
