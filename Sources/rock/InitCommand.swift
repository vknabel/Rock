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
      try rockfilePath.write("name: \(targetPath.parent().lastComponentWithoutExtension)\ndependencies:\n  - xcopen")
    }).mapError(RockError.rockfileCouldNotBeCreated)
  }
}
