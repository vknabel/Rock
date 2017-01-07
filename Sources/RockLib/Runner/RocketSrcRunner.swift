import PromptLine
import PathKit
import Result

public extension RocketSpec {
  public func clone(branch: String = "master", for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).clone(url: url, branch: branch)
          %? { RockError.rocketSourceCouldNotBeCloned(self, $0) }
    )
  }

  public func checkout(branch: String, for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).checkout(branch: branch)
          %? { RockError.rocketSourceCouldNotBeUpdated(self, $0) }
    )
  }

  public func pull(for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).pull()
          %? { RockError.rocketSourceCouldNotBeUpdated(self, $0) }
    )
  }

  public func fetch(for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).fetch(tags: true)
          %? { RockError.rocketSourceCouldNotBeFetched(self, $0) }
    )
  }
}
