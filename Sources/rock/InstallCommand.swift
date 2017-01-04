import Commandant
import PromptLine
import Result
import RockLib
import PathKit

struct InstallCommand: CommandProtocol {
  let verb: String = "install"
  let function: String = "Installs given rockets."
  
  func run(_ options: ProjectDependencyOptions) -> Result<(), RockError> {
    switch options.inputs {
    case let .left(dependencies):
      return runGlobal(dependencies)
    case let .right(project):
      return runProject(project)
    }
  }
  
  func runGlobal(_ dependencies: [Dependency]) -> Result<(), RockError> {
    return .failure(.notImplemented)
  }
  
  func runProject(_ project: RockProject) -> Result<(), RockError> {
    let rocketSpecs: Result<[(RocketSpec, Dependency.Version)], RockError> = project.rockfile.dependencies.flatMap {
      switch $0 { // into extension method
      case let .inlined(spec, version):
        return Result.success((spec, version))
      case let .named(name, version):
        // project.rocketSpec(named: name).map({ ($0, version) })
        return .failure(RockError.notImplemented)
      }
    }
    
    let install: Result<(), RockError> = rocketSpecs.flatMap({ rocketSpecs in
      rocketSpecs.flatMap({ (spec: (RocketSpec, Dependency.Version)) -> Result<Prompt, RockError> in
        let runner: PromptRunner<RockError> = report("Cloning", spec.0.name.theme.input, "from", spec.0.url.theme.derived, format: .step)
          %& spec.0.clone(for: project) %| spec.0.pull(for: project)
          %& Prompt.cd(project.sourcePath(for: spec.0))
          %& report("Building", spec.0.name.theme.input, format: .step)
          %& spec.0.buildRunner
          %& (Prompt.mkpath(project.binariesPath) %? { _ in .notImplemented })
          %& report("Linking", spec.0.name.theme.input, format: .step)
          %& spec.0.linkRunner
          %& report("Successfully installed", spec.0.name.theme.input, format: .success)
        return runner(project.prompt
          .declare("ROCK_SPEC_VERSION", as: spec.1)
          .declare("ROCKET_SPEC_NAME", as: spec.0.name)
        )
      }).map({ _ in () })
    })
    return install
  }
}
