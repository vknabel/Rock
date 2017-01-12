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

struct RunCommand: CommandProtocol {
    let verb: String = "run"
    let function: String = "Executes a script defined in your Rockfile."

    func run(_ options: RunProjectOptions) -> Result<(), RockError> {
      if let runner = options.project.rockfile.scriptRunners[options.script] {
        return runner(options.project.prompt.lensWorkingDirectory(to: "."))
          .map({ _ in () })
      } else {
        return .failure(RockError.rockfileCustomScriptNotFound(options.script))
      }
    }
}
