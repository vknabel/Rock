import RockLib
import PromptLine

extension ReporterFormat {
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
