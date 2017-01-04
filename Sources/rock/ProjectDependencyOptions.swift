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

enum Either<A, B> {
  case left(A)
  case right(B)
  
  static func options<ClientError: Error>(_ lhs: @escaping (CommandMode) -> Result<A, CommandantError<ClientError>>, _ rhs: @escaping (CommandMode) -> Result<B, CommandantError<ClientError>>) -> (CommandMode) -> Result<Either<A, B>, CommandantError<ClientError>> {
    return { m in
      switch m {
      case .arguments(_):
        return (m <| lhs).map(Either<A, B>.left).flatMapError({ _ in
          (m <| rhs).map(Either<A, B>.right)
        })
      case .usage:
        let leftUsage = (.usage <| lhs).error?.description ?? "left"
        let rightUsage = (.usage <| rhs).error?.description ?? "right"
        return .failure(CommandantError.usageError(description: "Either \n    \(leftUsage)\n  or\n    \(rightUsage)"))
      }
    }
  }
}

