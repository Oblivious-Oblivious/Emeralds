# Emeralds

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![GPLv3 License](https://img.shields.io/badge/license-GPL%20v3-yellow.svg)](./LICENSE)

[![CI](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3ACI)
[![CI (nightly)](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI%20(nightly)/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3A%22CI+%28nightly%29%22)

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

* Fix makefile generation to use $(shell) instead of regular $()
* Fix a bug where it crashes the array search when getting a field from the yaml files
* Add functionality for creating new .c/.h pairs with include guards etc.
* Convert bash searches to crystal glob serches for writing makefile fields
* Include installation instructions for wget and git requirements

## Contributing

1. Fork it (<https://github.com/Oblivious-Oblivious/Emeralds/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Oblivious](https://github.com/Oblivious-Oblivious) - creator and maintainer
