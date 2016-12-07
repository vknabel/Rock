# Rock

With Rock you can easily install CLIs build with Swift Package Manager.
The index of all supported libraries can be found on the [RockSpecs](https://github.com/vknabel/RockSpecs) repository.

## Overview

Rockets (aka 🚀) are SwiftPM projects.
Each 🚀 has a [RocketSpec](https://github.com/vknabel/RockSpecs/blob/master/default.yaml) which defines the Git url and how it has to be installed.
The compiled 🚀 will be stored as binary inside the RockSet's bin folder.

Rockets may be installed by using `rock install some_rocket`.

A RockSet is a namespace for 🚀 which is isolated from others.

***Note:*** *Currently only two RockSets called `global` and `local` is supported.*

RockSpecs include many RocketSpecs. You can checkout the default one [here](https://github.com/vknabel/RockSpecs).

***Note:*** *Currently only the `default` RockSpec is supported.*

You may install 🚀, that are not listed in the [RockSpecs](https://github.com/vknabel/RockSpecs) repository once you added them to your `local` RockSpec.

```bash
$ rock spec add vknabel/Rock --install --default
👉 Cloning https://github.com/vknabel/RockSpecs to /Users/vknabel/.rock/rockspecs/default
👉 Cloning rock
👉 Checking swift version
👉 rock requires Swift 3.0.1 (set by /Users/vknabel/nativedev/Rock/.swift-version)
👉 Installing rock
🏃 swift build -c release
🏃 rm -f /Users/vknabel/.rock/rocksets/global/bin/rock
🏃 cp .build/release/rock /Users/vknabel/.rock/rocksets/global/bin
✅ Successfully installed rock 🚀!
```

## Installation

First add the rock-bin to your `$PATH` variable to your `.bashrc`, `.bash_profile` or `.zshrc`.

```bash
ROCK_PATH="$HOME/.rock" # default, optional
PATH="$PATH:$ROCK_PATH/rocksets/global/bin"
```

Thereafter start 🎸ing your 🚀s by simply cloning the repository, building the swift module and installing rock itself.

```bash
$ git clone https://github.com/vknabel/rock
$ cd rock
$ swift build
$ ./.build/debug/rock install rock
```

## Limitations

- Rock has been designed to support different environments, but it currently only supports `global` and `custom`. Later there will be `.rockset` files, that are similar to `.gemset` or `.swift-version` files.
- Currently there is no version handling. Instead only the `master` branch will be checked out. Therefore `rock install` will only clone the targeted repository, whereas `rock update` will pull the current `master` branch.
- Error messages are either poor or non-existent.
- For now there is no mechanism to support global installations of libraries. This would allow to automatically fetch missing dependencies and run swift scripts on the fly (without compilation).

## Author

Valentin Knabel, [@vknabel](https://twitter.com/vknabel), dev@vknabel.com

## License

Rock is available under the [MIT](LICENSE) license.
