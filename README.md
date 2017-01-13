# Rock

With Rock you can easily manage your Project, metadata and Swift CLI dependencies. Additionally you can install Swift CLIs globally.
The index of all supported libraries can be found on the [RockSpecs](https://github.com/vknabel/RockSpecs) repository,
but you can declare your own at your `Rockfile`.

## Overview

Dependencies are called Rockets (aka 🚀). If they can be build with the Swift Package Manager, they should already be compatible out of the box.
Each 🚀 has a [RocketSpec](https://github.com/vknabel/RockSpecs/blob/master/default.yaml) which defines the Git url and how it has to be installed.

### Project

You can create a project by simply running:

```bash
$ rock init
```

This will create you an empty `Rockfile` which declares all your dependencies and metadata.

```yaml
name: YourProject
dependencies:
  - empty # Just an empty dependency that installs fast
  # Insert your dependencies here
  # - sourcery@0.5.2
  # - name: owncli
  #   url: https://github.com/your/owncli
```

Additionally you may create any additional tags.
Each value will be interpreted as a Stencil template,
that will be executed in a context of all previously declared values.
The tags `constants`, `version`, `license`, `name` and `url` will have precedence.

After you have set up your metadata and dependencies, you can install those by running:

```bash
$ rock install
```

Now you can work with all your CLIs. If you want to create your own custom scripts, you can add the script tag:

```yaml
name: YourProject
dependencies: [] # your dependencies
author:
  name: Valentin Knabel
  email: dev@vknabel.com
scripts:
  hello: echo Hello {{ author.name }}
  xcodeproj:
    - swift package generate-xcodeproj
    - open {{ name }}.xcodeproj
```

Thereafter you are able to run all your scripts with ease:

```bash
$ rock run hello
Hello Valentin Knabel
```

Additionally there are convenience commands with default scripts made for the Swift Package Manager:

```bash
$ rock build
🏃 swift build
$ rock test
🏃 swift test
$ rock archive
🏃 swift build -c release
```

### Global

Installing dependencies globally is currently only supported for Rockets that can be found in the [RockSpecs](https://github.com/vknabel/RockSpecs) repository.
You may install them by simply running:

```bash
# With a fixed version/tag/branch
$ rock install sourcery@0.5.2 swiftlint@0.16.0
# Or using the default (e.g. master)
$ rock install swiftgen
```

If you want to uninstall specific Rockets, just run:

```bash
$ rock uninstall sourcery swiftlint swiftgen
```

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

Alternatively you may try out our Swift Installer (you still need to set up your `$PATH` and `ROCK_PATH`):

```bash
$ curl -sL https://raw.githubusercontent.com/vknabel/Rock/master/Scripts/Install.generated.swift | swift -
```

### Updates

Rock can be updated by simply running installing itself with a version specified.
```bash
$ rock install rock@0.2.1
```

## Limitations

- Rock downloads and compiles all of your dependencies isolated and therefore installations may take a while.
- Currently there is no version handling. Instead only the `master` branch will be checked out by default.

## Author

Valentin Knabel, [@vknabel](https://twitter.com/vknabel), dev@vknabel.com

## License

Rock is available under the [MIT](LICENSE) license.
