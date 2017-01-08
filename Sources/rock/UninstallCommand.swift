import Commandant
import PromptLine
import Result
import RockLib
import PathKit
import Foundation

struct UninstallCommand: CommandProtocol {
  let verb: String = "uninstall"
  let function: String = "Uninstalls rockets. If no rockets are given, a project is assumed."

  func run(_ options: ProjectRocketOptions) -> Result<(), RockError> {
    switch options.inputs {
    case let .left(rockets):
      return rockets.flatMap({ name in
        Result<(), NSError>(attempt: (RockConfig.rockConfig.rockPath + "bin" + name).delete)
          .flatMap({ _ in Result<(), NSError>(attempt: (RockConfig.rockConfig.rockPath + "sources" + name).delete) })
          .mapError(RockError.rocketsCouldNotBeUninstalled)
      }).map({ _ in () })
    case let .right(project):
      return Result<(), NSError>(attempt: project.rockPath.delete)
        .mapError(RockError.rocketsCouldNotBeUninstalled)
    }
  }
}
