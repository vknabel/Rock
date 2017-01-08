import Foundation
import PromptLine
import PathKit
import Result

public extension RockSpec {
  private var repository: Repository {
    return Repository(path: path)
  }

  public func clone() -> PromptRunner<RockError> {
    if url == "" {
      return repository.create()
        %? { RockError.specsRepoCouldNotBeCloned(self, $0) }
    } else {
      return repository.clone(url: url)
        %? { RockError.specsRepoCouldNotBeCloned(self, $0) }
    }
  }

  public func update() -> PromptRunner<RockError> {
    return repository.pull()
      %? { RockError.specsRepoCouldNotBeUpdated(self, $0) }
  }

  public func rocket(named name: String) -> Result<RocketSpec, RockError> {
    let targetPath = specsPath + "\(name).yaml"
    return RocketSpec.fromPath(targetPath, named: name)
  }
}
