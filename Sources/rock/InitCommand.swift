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
        "name: \(targetPath.lastComponentWithoutExtension)",
        "version: 0.1.0",
        "# Dependencies may be installed locally by running `rock install`",
        "# If you like you can even delcare Specs inline or override specific scripts.",
        "dependencies:",
        "  - swiftlint@0.15.0",
        "",
        "# Scripts can be run as `rock run hello`",
        "# If you are using a SwiftPM Project, the scripts build, test, install and clean will be inferred.",
        "# Like everywhere in this Rockfile, you can use Stencil syntax inside your script values.",
        "# Searching for script ideas? Why not try write docs or publish scripts?",
        "scripts:",
        "  hello: # run me as `rock run hello`",
        "    - echo Hello {{name}}",
        "  lint:",
        "    - swiftlint autocorrect",
        "    - swiftlint",
        ""
      ].reduce("name: \(targetPath.lastComponentWithoutExtension)") { "\($0)\n\($1)"}
      try rockfilePath.write(rockfile)
    }).mapError(RockError.rockfileCouldNotBeCreated)
  }
}
