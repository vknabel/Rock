import Commandant
import PromptLine
import Result
import RockLib
import PathKit

struct InstallCommand: CommandProtocol {
  let verb: String = "install"
  let function: String = "Installs rockets. If no rockets are given, a project is assumed."

  func run(_ options: ProjectDependencyOptions) -> Result<(), RockError> {
    // Always update
    let defaultSpecs = RockSpec()
    let rockSpecs = defaultSpecs.path.exists
      ? report("Updating specs repository", defaultSpecs.name.theme.coded, format: .step)
        %& defaultSpecs.update()
      : report(
          "Cloning specs repository",
          defaultSpecs.name.theme.coded,
          "from",
          defaultSpecs.url.theme.coded,
          format: .step
        )
      %& defaultSpecs.clone()
    _ = rockSpecs(Prompt())

    switch options.inputs {
    case let .left(dependencies):
      return runGlobal(dependencies)
    case let .right(project):
      return runProject(project)
    }
  }

  func runGlobal(_ dependencies: [Dependency]) -> Result<(), RockError> {
    let project = RockProject(
      rockfile: Rockfile.global(with: dependencies),
      rockPath: RockConfig.rockConfig.rockPath.parent()
    )
    return runProject(project)
  }

  func rocketSpecs(for project: RockProject) -> Result<[(RocketSpec, Dependency.Version)], RockError> {
    return project.rockfile.dependencies.flatMap {
      switch $0 { // into extension method
      case let .inlined(spec, version):
        let v: Dependency.Version = version  ?? "master"
        return Result.success((spec, v))
      case let .named(name, version):
        return project.rocketSpec(named: name).map { ($0, version ?? "master") }
      case let .overriding(name, yaml, version):
        return project.rocketSpec(named: name)
          .map { $0.overriding(with: yaml) }
          .map { ($0, version ?? "master") }
      }
    }
  }

  func runProject(_ project: RockProject) -> Result<(), RockError> {
    let rocketSpecs = self.rocketSpecs(for: project)

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
            %& spec.0.fetch(for: project)
            %& spec.0.checkout(branch: spec.1, for: project)
            %& spec.0.pull(for: project)
          : report(
              "Cloning",
              spec.0.name.theme.input,
              "from",
              spec.0.url.theme.derived,
              "at",
              spec.1.theme.derived,
              format: .step
            )
            %& spec.0.clone(branch: spec.1, for: project)
            %& Prompt.cd(project.sourcePath(for: spec.0))
        let runner: PromptRunner<RockError> = cloneOrFetch
          %& Prompt.cd(project.sourcePath(for: spec.0))
          %& report("Building", spec.0.name.theme.input, format: .step)
          %& spec.0.buildRunner
          %& (Prompt.mkpath(project.binariesPath)
            %? { _ in RockError.notImplemented("No error handler for mkpath binaries") })
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
