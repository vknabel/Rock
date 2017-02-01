import RockLib
import Result
import PromptLine

internal func >- <E: Error>(prompt: Prompt, runner: PromptRunner<E>) -> Result<Prompt, E> {
  return runner(prompt)
}

extension ReporterFormat {
  static var phase = ReporterFormat(prefix: "🏎")
  static var step = ReporterFormat(prefix: "👉")
  static var success = ReporterFormat(prefix: "✅")
  static var question = ReporterFormat(prefix: "❓", terminator: "")
  static var error = ReporterFormat(prefix: "🚫 failed:".theme.error)
}

extension RockSpec {
  public var cloneReporter: PromptRunner<RockError> {
    return report("Cloning", url.theme.derived, "to", path.theme.derived, format: .step)
  }
}
