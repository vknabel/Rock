import Commandant
import Result
import RockLib

struct ProjectDependencyOptions: OptionsProtocol {
  let inputs: Either<[Dependency], RockProject>
  
  static func evaluate(_ m: CommandMode) -> Result<ProjectDependencyOptions, CommandantError<RockError>> {
    return ProjectDependencyOptions.init
      <*> m <| Either<[Dependency], RockProject>.options({ $0 <| dependencyArguments }, RockProject.fromOptions)
  }
}
