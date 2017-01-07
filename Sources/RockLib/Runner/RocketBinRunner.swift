import PathKit
import Result
import PromptLine

public extension RocketSpec {
  public func unlink<V>(for project: RockProject) -> (_ value: V) -> Result<V, RockError> {
    return { value in
      do {
        try project.binaryPath(for: self).delete()
        return .success(value)
      } catch {
        return .failure(RockError.rocketBinaryCouldNotBeUnlinked(self))
      }
    }
  }
}
