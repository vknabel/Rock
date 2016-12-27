import RockLib
import PromptLine

extension RockSpec {
  public var cloneReporter: PromptRunner<RockError> {
    return report("Cloning", url.theme.derived, "to", path.theme.derived, format: .step)
  }
}
