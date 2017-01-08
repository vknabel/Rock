import Commandant
import PathKit
import RockLib
import Result

extension Path: ArgumentProtocol {
  public static var name = "path"

  public static func from(string: String) -> Path? {
    return Path.current + string
  }
}

extension Dependency: ArgumentProtocol {
  public static var name = "rocket[@version]"
}

let projectOption = Option(
  key: "project",
  defaultValue: Path.current,
  usage: "The target project. It should contain the Rockfile"
)
let rocketArguments = Argument<[Dependency.Name]>(usage: "A list of rockets")
let dependencyArguments = Argument<[Dependency]>(usage: "A list of rockets, optionally including a version")

extension RockProject {
  static func fromOptions(_ m: CommandMode) -> Result<RockProject, CommandantError<RockError>> {
    let path: Result<Path, CommandantError<RockError>> = m <| projectOption
    return path.flatMap({ path in
      Rockfile.fromPath(path).mapError(CommandantError.commandError)
        .map {
          RockProject(rockfile: $0, rockPath: path)
      }
    })
  }
}
