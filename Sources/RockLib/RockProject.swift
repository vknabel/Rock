import Foundation
import PathKit
import PromptLine
import Result

public struct RockProject {
  public let rockPath: Path
  public let specsPath: Path
  public let rockfile: Rockfile

  public init(rockfile: Rockfile, rockPath: Path, specsPath: Path = RockConfig.rockConfig.rockSpecsPath) {
    self.rockfile = rockfile
    self.rockPath = rockPath + ".rock"
    self.specsPath = specsPath
  }
}

public extension RockProject {
  public var binariesPath: Path {
    return rockPath + "bin"
  }

  public func binaryPath(for spec: RocketSpec) -> Path {
    return binariesPath + spec.name
  }

  public var sourcesPath: Path {
    return rockPath + "sources"
  }

  public func sourcePath(for spec: RocketSpec) -> Path {
    return sourcesPath + spec.name
  }

  public func repository(for spec: RocketSpec) -> Repository {
    return Repository(path: sourcePath(for: spec))
  }

  public func mkSources() -> PromptRunner<RockError> {
    return Prompt.mkpath(self.sourcesPath)
      %? RockError.couldNotCreateSourcesDirectory
  }
}

public extension RockProject {
  public var prompt: Prompt {
    return Prompt(workingDirectory: rockPath, environment: ProcessInfo.processInfo.environment)
      .declare("ROCK_PATH", as: rockPath.description)
      .declare("ROCK_SPECS_PATH", as: specsPath.description)
  }

  public func rocketSpec(named name: String) -> Result<RocketSpec, RockError> {
    return RockSpec().rocket(named: name)
  }
}
