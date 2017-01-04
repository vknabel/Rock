import PromptLine
import PathKit
import Result

public extension RocketSpec {
  public func clone(for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).clone(url: url)
          %? { RockError.rocketSourceCouldNotBeCloned(self, $0) }
    )
  }
  
  public func pull(for project: RockProject) -> PromptRunner<RockError> {
    return project.mkSources()
      %& (
        project.repository(for: self).fetch(tags: true)
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
