import PromptLine
import PathKit
import Result

public extension RocketSrc {
  private var repository: Repository {
    return Repository(path: path)
  }
  
  public func clone() -> PromptRunner<RockError> {
    return Prompt.mkpath(path.parent())
      %& repository.clone(url: spec.url)
      %? { RockError.rocketSourceCouldNotBeCloned(self, $0) }
  }
  
  public func pull() -> PromptRunner<RockError> {
    return Prompt.mkpath(path.parent())
      %& repository.fetch(tags: true)
      %? { RockError.rocketSourceCouldNotBeUpdated(self, $0) }
  }
  
  public func fetch() -> PromptRunner<RockError> {
    return Prompt.mkpath(path.parent())
      %& repository.fetch(tags: true)
      %? { RockError.rocketSourceCouldNotBeFetched(self, $0) }
  }
}
