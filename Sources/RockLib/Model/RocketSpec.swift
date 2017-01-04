import PromptLine
import Result
import Yaml

private extension Yaml {
  var stringArray: [String]? {
    if let s = string {
      return [s]
    } else {
      return array?.flatMap({ $0.string })
    }
  }
}

public struct RocketSpec {
  public typealias Runner = PromptRunner<RockError>
  public let name: String
  public let url: String
  public let buildRunner: Runner
  public let linkRunner: Runner
  public let unlinkRunner: Runner
  public let cleanRunner: Runner

  public init(
    name: String,
    url: String,
    build: PromptRunner<PromptError>? = nil,
    link: PromptRunner<PromptError>? = nil,
    unlink: PromptRunner<PromptError>? = nil,
    clean: PromptRunner<PromptError>? = nil
  ) {
    self.name = name
    self.url = url
    self.buildRunner = (build ?? RockConfig.rockConfig.buildRunner) %? RockError.rocketSpecCouldNotBeBuilt
    self.linkRunner = (link ?? RockConfig.rockConfig.linkRunner) %? RockError.rocketSpecCouldNotBeLinked
    self.unlinkRunner = (unlink ?? RockConfig.rockConfig.unlinkRunner) %? RockError.rocketSpecCouldNotBeUnlinked
    self.cleanRunner = (clean ?? RockConfig.rockConfig.cleanRunner) %? RockError.rocketSpecCouldNotBeCleaned
  }
}

public extension RocketSpec {
  public init(
    name: String,
    url: String,
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
      build: runnerFromStrings(build),
      link: runnerFromStrings(link),
      unlink: runnerFromStrings(unlink),
      clean: runnerFromStrings(clean)
    )
  }
}

public extension RocketSpec {
  public static func fromYaml(_ yaml: Yaml, named name: String) -> Result<RocketSpec, RockError> {
    guard let url = yaml["url"].string else { return .failure(RockError.rocketSpecRequiresAnUrl(name: name)) }
    return .success(RocketSpec(
      name: name,
      url: url,
      build: yaml["build"].stringArray ?? [],
      link: yaml["link"].stringArray ?? [],
      unlink: yaml["unlink"].stringArray ?? [],
      clean: yaml["clean"].stringArray ?? []
    ))
  }
}
