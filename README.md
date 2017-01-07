# Rock

With Rock you can easily install CLIs built with Swift Package Manager locally and globally.
The index of all supported libraries can be found on the [RockSpecs](https://github.com/vknabel/RockSpecs) repository,
but you can declare your own at your `Rockfile`.

## Overview

Rockets (aka 🚀) are SwiftPM projects.
Each 🚀 has a [RocketSpec](https://github.com/vknabel/RockSpecs/blob/master/default.yaml) which defines the Git url and how it has to be installed.
The compiled 🚀 will be stored as binary inside the RockSet's bin folder.

Rockets may be installed globally by using `rock install some_rocket` and locally by creating a `Rockfile` containing all dependencies and running `rock install`.

```yaml
name: YourProject
dependencies:
  - empty # Just an empty dependency that installs fast
  # Insert your dependencies here
```

In order to install all your dependencies simply run:

```bash
$ rock install
👉 Updating specs repository global
Already up-to-date.
👉 Installing empty@master
👉 Updating master of empty
Already on 'master'
Your branch is up-to-date with 'origin/master'.
Already up-to-date.
👉 Building empty
🏃 swift build -c release
👉 Linking empty
🏃 cp .build/release/$ROCKET_SPEC_NAME $ROCK_PATH/bin
✅ Successfully installed empty
```

RockSpecs include many RocketSpecs. You can checkout the default one [here](https://github.com/vknabel/RockSpecs).

***Note:*** *Currently only the `default` RockSpec is supported.*

You may install 🚀, that are not listed in the [RockSpecs](https://github.com/vknabel/RockSpecs) repository by adding them to your `Rockfile`.

## Installation

First add the rock-bin to your `$PATH` variable to your `.bashrc`, `.bash_profile` or `.zshrc`.

```bash
export ROCK_PATH="$HOME/.rock" # default
export PATH="$PATH:./.rock/bin:$ROCK_PATH/bin"
```

Thereafter start 🎸ing your 🚀s by simply cloning the repository, building the swift module and installing rock itself.

```bash
$ git clone https://github.com/vknabel/rock $ROCK_PATH/sources/rock
$ cd $ROCK_PATH/sources/rock
$ swift build
$ mkdir $ROCK_PATH/bin
$ cp $ROCK_PATH/sources/rock/.build/debug/rock $ROCK_PATH/bin
```

## Limitations

- Currently there is no version handling. Instead only the `master` branch will be checked out. Therefore `rock install` will only clone the targeted repository, whereas `rock update` will pull the current `master` branch.

## Author

Valentin Knabel, [@vknabel](https://twitter.com/vknabel), dev@vknabel.com

## License

Rock is available under the [MIT](LICENSE) license.
