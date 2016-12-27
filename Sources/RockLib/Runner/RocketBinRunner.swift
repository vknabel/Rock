import PathKit
import Result
import PromptLine

public extension RocketBin {
  public func unlink<V>() -> (_ value: V) -> Result<V, RockError> {
    return { value in
      do {
        try self.path.delete()
        return .success(value)
      } catch {
        return .failure(RockError.rocketBinaryCouldNotBeUnlinked(self))
      }
    }
  }
}
