# Rock

## Master

### Breaking Changes

- **[Rock]** Dropped RockSet support in `~/.rock` - @vknabel

### Additions

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

- In your `.bashrc`, `.bash_profile` or `.zshrc` replace `export PATH="$PATH:$ROCK_PATH/rocksets/global/bin"` with `export PATH="$PATH:$ROCK_PATH/bin"`.

## 0.1.0

- Initial Release - @vknabel
