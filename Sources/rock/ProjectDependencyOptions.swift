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

struct ProjectRocketOptions: OptionsProtocol {
  let inputs: Either<[Dependency.Name], RockProject>

  static func evaluate(_ m: CommandMode) -> Result<ProjectRocketOptions, CommandantError<RockError>> {
    return ProjectRocketOptions.init
      <*> m <| Either<[Dependency.Name], RockProject>.options({ $0 <| rocketArguments }, RockProject.fromOptions)
  }
}
