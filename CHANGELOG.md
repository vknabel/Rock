# Rock

## 0.3.1

### Non Breaking Changes

- **[Dependencies]** Upgraded `PathKit`, `Stencil` and `PromptLine` which fixes Linux issues

## 0.3.0

### Additions

- **[Rock]** Added pre- and post-hooks for all scripts
- **[Rock]** Added `rock lint` as an alias
- **[Rock]** Added `rock publish` as an alias
- **[Rock]** Added `rock init` generates improved data
- **[Rock]** Added `rock init` now tells you that it has succeeded
- **[Rockfile]** Reintroduces `clean` phase

### Non Breaking Changes

- **[Rockfile]** Rockfiles now interpret `"const", "constant"` keys first
- **[Rock]** Fixes second name line on `rock init`
- **[Rock]** Reduces output noise of rock itself
- **[Rock]** Clones are not recursive anymore

## 0.2.3

### Non Breaking Changes

- **[Rock]** Improved `rock init`

## 0.2.2

### Additions

- **[Rockfile]** Now supports more complex bash commands including &&

### Non Breaking Changes

- **[Dependencies]** Updated PromptLine for shell execution

## 0.2.1

### Additions

- **[Rock]** Now supports `rock version` - @vknabel
- **[Rock]** Now supports `rock run script` - @vknabel
- **[Rock]** Added convenience scripts for `rock build`, `rock test` and `rock archive` - @vknabel
- **[Rock]** Derived scripts that will be executed will be highlighted now - @vknabel
- **[Rockfile]** Every value in `Rockfile` will now be interpreted as Stencil template - @vknabel
- **[Rockfile]** Overriding single properties in `Rockfile` is now supported - @vknabel
- **[Other]** Provides experimental `Install.generated.swift` Installation Script - @vknabel

### Non Breaking Changes

- **[Project]** Now uses krzysztofzablocki/Sourcery - @vknabel
- **[Project]** Added Swiftlint - @vknabel
- **[Project]** Added Travis CI - @vknabel
- **[Project]** Added Danger - @vknabel
- **[Dependencies]** Uses ColorizeSwift for terminal colors instead of Swiftline - @vknabel

## 0.2.0

### Breaking Changes

- **[Rock]** Dropped RockSet support in `~/.rock` - @vknabel
- **[Rock]** Dropped `rock update` - @vknabel
- **[Rock]** Dropped `rock self-update` - @vknabel
- **[Rock]** Dropped `rock reinstall` - @vknabel
- **[Rock]** Dropped `rock clean` - @vknabel
- **[Rock]** Dropped `rock list` - @vknabel

### Additions

- **[Rock]** Adds support for `Rockfile` for projects - @vknabel
- **[RockLib]** Created Module `RockLib` - @vknabel
- **[RockLib]** Added support for `Rockfile` - @vknabel

### Non Breaking Changes

- **[Dependencies]** Uses `.git` for all direct dependencies - @vknabel
- **[Dependencies]** Replaced Commander with Commandant - @vknabel
- **[Dependencies]** Result instead of plain do-try-catch - @vknabel
- **[Dependencies]** Uses PromptLine for shell execution instead of Swiftline - @vknabel
- **[RockSpecs]** Deprecated `install`. Use `build` and `link` instead - @vknabel
- **[RockSpecs]** Deprecated `uninstall`. Use `unlink` instead - @vknabel

### Migration instructions

- Run `rock install rock@0.2.0`
- In your `.bashrc`, `.bash_profile` or `.zshrc` replace `export PATH="$PATH:$ROCK_PATH/rocksets/global/bin"` with `export PATH="$PATH:$ROCK_PATH/bin"`.
- Delete `$ROCK_PATH/rockspecs`

## 0.1.0

- Initial Release - @vknabel
