import Foundation
import Yaml
import Result
import PathKit
import PromptLine

public extension Array {
  func flatMap<ElementOfResult, ErrorOfResult: Error>(
    _ transform: (Element) -> Result<ElementOfResult, ErrorOfResult>
  ) -> Result<[ElementOfResult], ErrorOfResult> {
    return self.reduce(.success([]), { (previousResult, element) -> Result<[ElementOfResult], ErrorOfResult> in
      return previousResult.flatMap({ p in transform(element).map({ p + [$0] })})
    })
  }
}

public enum Dependency {
  public typealias Name = String
  public typealias Version = String

  case named(Name, Version?)
  case inlined(RocketSpec, Version?)
  case overriding(Name, Yaml, Version?)

  public static func from(string: String) -> Dependency? {
    let fragments = string.components(separatedBy: "@")
    guard let head = fragments.first else { return nil }
    let version = fragments.dropFirst().first
    return Dependency.named(head, version ?? "master")
  }
}

public extension Dependency {
    public static func fromYaml(_ yaml: Yaml) -> Result<Dependency, RockError> {
    switch yaml {
    case let .dictionary(root):
      if case .some(.string(_)) = root["url"], case let .some(.string(name)) = root["name"] {
        return RocketSpec.fromYaml(yaml, named: name)
          .map {
            Dependency.inlined($0, root["version"]?.string)
        }
      } else if case .some(.string(_)) = root["name"] {
        return .failure(.notImplemented("Dependencies by name are not supported yet"))
      }
      return .failure(.notImplemented("Cannot handle dictionary dependencies without url and name"))
    case let .string(name):
      return .success(Dependency.from(string: name) ?? .named(name, "master"))
    default:
      return .failure(.rockfileHasInvalidDependency)
    }
  }
}

/// Represents a Rockfile.yaml file.
///
/// ```yaml
/// swift-version: 3.0.1
/// dependencies:
/// - needless
/// - name: sourcery
///   version: 0.5.0
/// - name: langserver-swift
///   swift-version: DEVELOPMENT-SNAPSHOT-2016-12-01-a
/// - name: xcopen
///   url: https://github.com/vknabel/xcopen
/// ```
public struct Rockfile {
  public typealias Runner = PromptRunner<RockError>

  public let name: String
  public let dependencies: [Dependency]
  public let scriptRunners: [String: Runner]

  public static func global(with dependencies: [Dependency]) -> Rockfile {
    return Rockfile(name: "global", dependencies: dependencies, scriptRunners: [:])
  }
}

public extension Rockfile {
  public static func fromPath(_ path: Path) -> Result<Rockfile, RockError> {
    let yaml = Result<Yaml, AnyError>(attempt: {
      do {
        let text: String = try (path + "Rockfile").read()
        return try Yaml.rendering(text)
      } catch {
        throw AnyError(error)
      }
    }).mapError { anyError -> RockError in
      if case let Yaml.ResultError.message(message) = anyError.error {
        return RockError.rockfileIsNotValidYaml(message)
      } else {
        return RockError.rockfileCouldNotBeRead(path, anyError.error)
      }
    }
    return yaml.flatMap(Rockfile.fromYaml)
  }

  public static func fromYaml(_ yaml: Yaml) -> Result<Rockfile, RockError> {
    guard case let .dictionary(root) = yaml
      else { return .failure(.rockfileMustContainDictionary) }
    guard case let .some(.string(name)) = root["name"]
      else { return .failure(.rockfileMustHaveAName) }
    guard case let .some(.array(rawDependencies)) = root["dependencies"]
      else { return .failure(.rockfileMustHaveDependencies) }
    return rawDependencies.flatMap(Dependency.fromYaml).map {
      let defaultScripts = [
        "build": runnerFromStrings(yaml["build"].stringArray ?? [], or: RockConfig.rockConfig.debugBuildScript)
          %? { RockError.rockfileCustomScriptFailed("build", $0) },
        "test": runnerFromStrings(yaml["test"].stringArray ?? [], or: RockConfig.rockConfig.testScript)
        %? { RockError.rockfileCustomScriptFailed("test", $0) },
        "archive": runnerFromStrings(yaml["archive"].stringArray ?? [], or: RockConfig.rockConfig.archiveScript)
        %? { RockError.rockfileCustomScriptFailed("archive", $0) }
      ]
      let scripts = (yaml.dictionary?["scripts"]?.dictionary ?? [:])
        .reduce(defaultScripts, { (scripts, element) in
          if let name = element.key.string, let shell = element.value.stringArray {
            var scripts = scripts
            scripts[name] = runnerFromStrings(shell, or: []) %? { RockError.rockfileCustomScriptFailed(name, $0) }
            return scripts
          } else {
            return scripts
          }
        })

      return Rockfile(name: name, dependencies: $0, scriptRunners: scripts)
    }
  }
}
