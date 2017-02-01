import Commandant
import PromptLine
import Result
import RockLib

struct ProjectOptions: OptionsProtocol {
  let project: RockProject

  static func evaluate(_ m: CommandMode) -> Result<ProjectOptions, CommandantError<RockError>> {
    return (m <| RockProject.fromOptions)
      .map(ProjectOptions.init)
  }
}

struct ScriptCommand: CommandProtocol {
  let verb: String
  let script: String
  let function: String

  init(verb: String, script: String? = nil, function: String) {
    self.verb = verb
    self.script = script ?? verb
    self.function = function
  }

  func run(_ options: ProjectOptions) -> Result<(), RockError> {
    return RunCommand().run(
      RunProjectOptions(project: options.project, script: script)
    )
  }
}
