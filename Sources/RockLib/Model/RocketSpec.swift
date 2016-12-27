import PromptLine

public struct RocketSpec {
  public typealias Runner = PromptRunner<RockError>
  public let name: String
  public let url: String
  public let branch: String? /// tag or branch that won't be recognized by default
  public let buildRunner: Runner
  public let linkRunner: Runner
  public let unlinkRunner: Runner
  public let cleanRunner: Runner

  public init(
    name: String,
    url: String,
    branch: String? = nil,
    build: PromptRunner<PromptError>? = nil,
    link: PromptRunner<PromptError>? = nil,
    unlink: PromptRunner<PromptError>? = nil,
    clean: PromptRunner<PromptError>? = nil
  ) {
    self.name = name
    self.url = url
    self.branch = branch
    self.buildRunner = (build ?? RockConfig.rockConfig.buildRunner) %? RockError.specCouldNotBeBuilt
    self.linkRunner = (link ?? RockConfig.rockConfig.linkRunner) %? RockError.specCouldNotBeLinked
    self.unlinkRunner = (unlink ?? RockConfig.rockConfig.unlinkRunner) %? RockError.specCouldNotBeUnlinked
    self.cleanRunner = (clean ?? RockConfig.rockConfig.cleanRunner) %? RockError.specCouldNotBeCleaned
  }
}

public extension RocketSpec {
  public init(
    name: String,
    url: String,
    branch: String? = nil,
    build: [String] = [],
    link: [String] = [],
    unlink: [String] = [],
    clean: [String] = []
  ) {
    func nilIfEmpty<E>(_ array: [E]) -> [E]? {
      if array.isEmpty {
        return nil
      } else {
        return array
      }
    }
    func runnerFromStrings(_ raw: [String]) -> PromptRunner<PromptError>? {
      return nilIfEmpty(raw)?.map(>-).reduce(zeroRunner, %&)
    }
    
    self.init(
      name: name,
      url: url,
      branch: branch,
      build: runnerFromStrings(build),
      link: runnerFromStrings(link),
      unlink: runnerFromStrings(unlink),
      clean: runnerFromStrings(clean)
    )
  }
}
