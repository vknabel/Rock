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
    return .failure(RockError.notImplemented("Global installs are not supported by now"))
  }
  
  func runProject(_ project: RockProject) -> Result<(), RockError> {
    let rocketSpecs: Result<[(RocketSpec, Dependency.Version)], RockError> = project.rockfile.dependencies.flatMap {
      switch $0 { // into extension method
      case let .inlined(spec, version):
        return Result.success((spec, version))
      case let .named(name, version):
        return project.rocketSpec(named: name).map { ($0, version) }
      }
    }
    
    let defaultSpecs = RockSpec()
    let rockSpecs = defaultSpecs.path.exists
      ? report("Updating specs repository", defaultSpecs.name.theme.coded, format: .step)
        %& defaultSpecs.update()
      : report("Cloning specs repository", defaultSpecs.name.theme.coded, "from", defaultSpecs.url.theme.coded, format: .step)
      %& defaultSpecs.clone()
    _ = rockSpecs(Prompt())
    
    if let specs = rocketSpecs.value {
      let specDescriptions = specs.map({ "\($0.0.name.theme.input)@\($0.1.theme.derived)" })
      let log = report("Installing", specDescriptions.joined(separator: ", "), format: .step) as PromptReporter
      _ = log(project.prompt)
    }
    
    let install: Result<(), RockError> = rocketSpecs.flatMap({ rocketSpecs in
      rocketSpecs.flatMap({ (spec: (RocketSpec, Dependency.Version)) -> Result<Prompt, RockError> in
        let cloneOrFetch = project.sourcePath(for: spec.0).exists
          ? report("Updating", spec.1.theme.derived, "of", spec.0.name.theme.input, format: .step)
            %& Prompt.cd(project.sourcePath(for: spec.0))
            %& spec.0.checkout(branch: spec.1, for: project)
            %& spec.0.pull(for: project)
          : report("Cloning", spec.0.name.theme.input, "from", spec.0.url.theme.derived, "at", spec.1.theme.derived, format: .step)
            %& spec.0.clone(branch: spec.1, for: project)
            %& Prompt.cd(project.sourcePath(for: spec.0))
        let runner: PromptRunner<RockError> = cloneOrFetch
          %& Prompt.cd(project.sourcePath(for: spec.0))
          %& report("Building", spec.0.name.theme.input, format: .step)
          %& spec.0.buildRunner
          %& (Prompt.mkpath(project.binariesPath) %? { _ in RockError.notImplemented("No error handler for mkpath binaries") })
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
