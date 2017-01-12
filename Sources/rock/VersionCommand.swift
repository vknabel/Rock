import Commandant
import PromptLine
import Result
import RockLib

struct VersionCommand: CommandProtocol {
  let verb: String = "version"
  let function: String = "Prints out the current version of rock: \(RockConfig.version)"

  func run(_ options: NoOptions<RockError>) -> Result<(), RockError> {
    print(RockConfig.version)
    return .success()
  }
}
