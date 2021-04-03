# Emeralds

A module/package manager for C applications.  

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?)](https://crystal-lang.org/)
[![GPLv3 License](https://img.shields.io/badge/license-GPL%20v3-yellow.svg)](./COPYING)

[![CircleCI](https://circleci.com/gh/Oblivious-Oblivious/Emeralds.svg?style=shield)](https://circleci.com/gh/Oblivious-Oblivious/Emeralds)
[![CI](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3ACI)
[![CI (nightly)](https://github.com/Oblivious-Oblivious/Emeralds/workflows/CI%20(nightly)/badge.svg)](https://github.com/Oblivious-Oblivious/Emeralds/actions?query=workflow%3A%22CI+%28nightly%29%22)

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
* `em build app`
* `./export/testapp`
* `em clean`

## Development

* Add option for debug and release compilation
* Include installation instructions for wget and git requirements
* Remove the need for a makefile

## Contributing

1. Fork it (<https://github.com/Oblivious-Oblivious/Emeralds/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Oblivious](https://github.com/Oblivious-Oblivious) - creator and maintainer
