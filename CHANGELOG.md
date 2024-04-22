# Changes for Emeralds 1.2.0 (23-04-2024)

* Refactored codebase for easier management.
* Fixed makefile generation, now all find commands work properly.
* Added a new `run` command for running the compiled executable.
* Clean commands also remove dSYM files.

# Changes for Emeralds 1.1.0 (04-04-2021)

* Fixed display bugs on all operating systems.
* Implemented a cross platform compilation makefile.
* Added support for debug and release builds.
* Added support for counting lines of code in library emeralds.
* Moved documentation to individual classes rather than all together in a docs file.

# Changes for Emeralds 1.0.0 (04-03-2021)

* Fixed testing and CI for the project.
* Added compilation to static libraries.
* Added recursive installation of dependencies and code for each emerald.
* Added instructions for installation and usage.
* Added functionality for counting lines of code in the project.
* Added cSpec as a default dependency.
* Fixed directory bugs.

# Changes for Emeralds 0.2.0 (28-02-2021)

* Migrated the whole codebase to crystal-lang.

# Changes for Emeralds 0.1.0 (22-06-2020)

* Adds the first version of the package manager.
* Auto generates a .git repository with .gitignore declarations.
* Adds functionality for downloading dependencies from git.
* Has scripts for building as an executable or a shared library.
* Has test scripts and postinstall directives for recursive dependency management.
