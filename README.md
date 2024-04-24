# Emeralds

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![GPLv3 License](https://img.shields.io/badge/license-GPL%20v3-yellow.svg)](./LICENSE)

[![CI](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3ACI)

A module/package manager for C applications.

## Installation

Run the install script

```
./install
```

## Usage

`em help` # Prints the list of commands and how to use

### Sample usage
* `em init testapp`
* `cd testapp`
* `em list`
* `em install`
* `em install dev`
* `em test`
* `em build app release`
* `./export/testapp`
* `em clean`

## Development

* Make sure we store PWD at runtime so that symlinks do not break execution.
* Add functionality for creating new .c/.h pairs with include guards etc.
* Allow for custom cflags inside of emfile.
* Add an `em install all` command for both local and dev dependencies
* Include installation instructions for wget and git requirements.

## Contributing

1. Fork it (<https://github.com/Oblivious-Oblivious/Emeralds/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Oblivious](https://github.com/Oblivious-Oblivious) - creator and maintainer
