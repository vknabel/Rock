import Commandant
import PromptLine
import Result
import RockLib

struct RunProjectOptions: OptionsProtocol {
  let project: RockProject
  let script: String

  static func evaluate(_ m: CommandMode) -> Result<RunProjectOptions, CommandantError<RockError>> {
    return (m <| RockProject.fromOptions)
      .map({ project in { RunProjectOptions(project: project, script: $0) } })
    <*> m <| Argument(usage: "Script name")
  }
}

private func >- <E: Error>(prompt: Prompt, runner: PromptRunner<E>) -> Result<Prompt, E> {
  return runner(prompt)
}

struct RunCommand: CommandProtocol {
    let verb: String = "run"
    let function: String = "Executes a script defined in your Rockfile."

    func run(_ options: RunProjectOptions) -> Result<(), RockError> {
      let runners = options.project.rockfile.scriptRunners
      if let runner = runners[options.script] {
        let prompt = options.project.prompt.lensWorkingDirectory(to: ".")
        let preRunner = runners["pre" + options.script] ?? Result.success
        let postRunner = runners["post" + options.script] ?? Result.success
        return (prompt >- report("Running", "pre\(options.script)".theme.derived, format: .phase) %& preRunner
            %& report("Running", options.script.theme.input, format: .phase) %& runner
            %& report("Running", "post\(options.script)".theme.derived, format: .phase) %& postRunner
          )
          .map({ _ in () })
      } else {
        return .failure(RockError.rockfileCustomScriptNotFound(options.script))
      }
    }
}
