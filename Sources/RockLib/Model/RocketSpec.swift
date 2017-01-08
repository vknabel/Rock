import PromptLine
import Result
import PathKit
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
    build: @escaping PromptRunner<PromptError>,
    link: @escaping PromptRunner<PromptError>,
    unlink: @escaping PromptRunner<PromptError>,
    clean: @escaping PromptRunner<PromptError>
  ) {
    self.name = name
    self.url = url
    self.buildRunner = build %? RockError.rocketSpecCouldNotBeBuilt
    self.linkRunner = link %? RockError.rocketSpecCouldNotBeLinked
    self.unlinkRunner = unlink %? RockError.rocketSpecCouldNotBeUnlinked
    self.cleanRunner = clean %? RockError.rocketSpecCouldNotBeCleaned
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
    func runnerFromStrings(_ raw: [String], or fallback: [String]) -> PromptRunner<PromptError> {
      return (nilIfEmpty(raw) ?? fallback).map({ report($0, format: .script) %& >-$0 }).reduce(zeroRunner, %&)
    }

    self.init(
      name: name,
      url: url,
      build: runnerFromStrings(build, or: RockConfig.rockConfig.buildScript),
      link: runnerFromStrings(link, or: RockConfig.rockConfig.linkScript),
      unlink: runnerFromStrings(unlink, or: RockConfig.rockConfig.unlinkScript),
      clean: runnerFromStrings(clean, or: RockConfig.rockConfig.cleanScript)
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

  public static func fromPath(_ path: Path, named name: String) -> Result<RocketSpec, RockError> {
    let yaml = Result<Yaml, AnyError>(attempt: {
      do {
        let text: String = try path.read()
        return try Yaml.load(text)
      } catch {
        throw AnyError(error)
      }
    }).mapError { anyError -> RockError in
      if case let Yaml.ResultError.message(message) = anyError.error {
        return RockError.rocketSpecIsNotValidYaml(message)
      } else {
        return RockError.rocketSpecCouldNotBeRead(path, anyError.error)
      }
    }
    return yaml.flatMap { RocketSpec.fromYaml($0, named: name) }
  }
}
