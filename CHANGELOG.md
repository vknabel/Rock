# Rock

## Master

### Non Breaking Changes

- **[Project]** Added Swiftlint - @vknabel
- **[Project]** Added Travis CI - @vknabel
- **[Project]** Added Danger - @vknabel

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
