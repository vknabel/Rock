import Foundation
import Commandant
import Result
import PathKit
import RockLib

struct InitCommand: CommandProtocol {
  let verb: String = "init"
  let function: String = "Initializes an empty Rockfile"

  func run(_ options: NoOptions<RockError>) -> Result<(), RockError> {
    let targetPath = Path.current
    let rockfilePath = targetPath + "Rockfile"
    if rockfilePath.exists {
      return Result(error: .rockfileAlreadyExists)
    }
    return Result<(), NSError>(attempt: {
      let rockfile = [
        // name defined in reduce
        "url: https://github.com/\(targetPath.parent().lastComponentWithoutExtension)/\(targetPath.lastComponentWithoutExtension)",
        "version: 0.1.0",
        "# Dependencies may be installed locally by running `rock install`",
        "# If you like you can even delcare Specs inline or override specific scripts.",
        "dependencies:",
        "  - swiftlint@0.15.0",
        "",
        "# Scripts can be run as `rock run hello`",
        "# If you are using a SwiftPM Project, the scripts build, test, install and clean will be inferred.",
        "# Like everywhere in this Rockfile, you can use Stencil syntax inside your script values.",
        "# Before each script is executed, it's pre variant will be executed.",
        "# Once a script finshes, it's post variant is called.",
        "# Searching for script ideas? Why not try write docs or publish scripts?",
        "scripts:",
        "  # build, test, install and clean are inferred",
        "  xcode:",
        "    # Generate Project. Optionally: customize",
        "    - swift package generate-xcodeproj --enable-code-coverage",
        "  postxcode: # Will automatically run after xcode",
        "    - open {{name}}.xcodeproj",
        "  lint:",
        "    - swiftlint autocorrect",
        "    - swiftlint",
        "  prepublish:",
        "    # Run your linter before publishing",
        "    - rock lint",
        "    # Releases may only be made on branch master",
        "    - |",
        "        if [ $(git branch | grep \\* | cut -d ' ' -f2) != \"master\" ]; then",
        "          echo Releases must be created from branch master >&2",
        "          exit 1",
        "        fi",
        "  publish: # Will automatically run prepublish",
        "    # Assert clean working directory",
        "    - git diff --exit-code > /dev/null",
        "    # Set git tag",
        "    - git tag -a {{version}} -m {{version}}",
        "    - git push --tags",
        "    # Copy latest Changelog",
        "    - sed -n /'^## {{version}}$'/,/'^## '/p CHANGELOG.md | sed -e '$ d' | pbcopy",
        "    # Create new release on Github",
        "    - open {{url}}/releases/new?tag={{version}}",
        "    # Publish to CocoaPods",
        "    - |",
        "        if [ -a {{name}}.podspec ]; then ",
        "           bundle exec pod trunk push {{name}}.podspec --allow-warnings --swift-version=3.0",
        "        fi",
        ""
      ].reduce("name: \(targetPath.lastComponentWithoutExtension)") { "\($0)\n\($1)"}
      try rockfilePath.write(rockfile)
    }).mapError(RockError.rockfileCouldNotBeCreated)
  }
}
