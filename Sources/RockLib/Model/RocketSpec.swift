import PromptLine
import Result
import PathKit
import Yaml

internal extension Yaml {
  var stringArray: [String]? {
    if let s = string {
      return [s]
    } else {
      return array?.flatMap({ $0.string })
    }
  }
}

fileprivate func nilIfEmpty<E>(_ array: [E]) -> [E]? {
  if array.isEmpty {
    return nil
  } else {
    return array
  }
}

internal func runnerFromStrings(_ raw: [String], or fallback: [String]) -> PromptRunner<PromptError> {
  return (nilIfEmpty(raw) ?? fallback).map({ report($0, format: .script) %& >-$0 }).reduce(zeroRunner, %&)
}

internal func runnerFromStrings(_ raw: [String]) -> PromptRunner<PromptError>? {
  return nilIfEmpty(raw)?.map({ report($0, format: .script) %& >-$0 }).reduce(zeroRunner, %&)
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

  public init(
    name: String,
    url: String,
    buildRunner: @escaping Runner,
    linkRunner: @escaping Runner,
    unlinkRunner: @escaping Runner,
    cleanRunner: @escaping Runner
    ) {
    self.name = name
    self.url = url
    self.buildRunner = buildRunner
    self.linkRunner = linkRunner
    self.unlinkRunner = unlinkRunner
    self.cleanRunner = cleanRunner
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
  public func overriding(with yaml: Yaml) -> RocketSpec {
    let build: Runner = runnerFromStrings(yaml["build"].stringArray ?? [])
      .map({ $0 %? RockError.rocketSpecCouldNotBeBuilt })
      ?? buildRunner
    let link: Runner = runnerFromStrings(yaml["link"].stringArray ?? [])
      .map({ $0 %? RockError.rocketSpecCouldNotBeLinked })
      ?? linkRunner
    let unlink: Runner = runnerFromStrings(yaml["unlink"].stringArray ?? [])
      .map({ $0 %? RockError.rocketSpecCouldNotBeUnlinked })
      ?? unlinkRunner
    let clean: Runner = runnerFromStrings(yaml["clean"].stringArray ?? [])
      .map({ $0 %? RockError.rocketSpecCouldNotBeCleaned })
      ?? cleanRunner
    return RocketSpec(
      name: yaml["name"].string ?? name,
      url: yaml["url"].string ?? url,
      buildRunner: build,
      linkRunner: link,
      unlinkRunner: unlink,
      cleanRunner: clean
    )
  }

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
        return try Yaml.rendering(text)
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
