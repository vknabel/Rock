import Foundation
import PromptLine
import PathKit

fileprivate extension Dictionary {
  func updatingValue(_ value: Value, forKey key: Key) -> Dictionary {
    var copy = self
    copy[key] = value
    return copy
  }
}

public struct RockConfig {
  internal static let rockPathEnvVar: String = "ROCK_PATH"
  public static let rockConfig = RockConfig()
  
  public let rockPath: Path
  public let shellEnv: [String: String]
  
  public let buildRunner = >-"swift build -c release"
  public let unlinkRunner = >-"rm -f $ROCKSET_PATH/bin/$ROCKET_SPEC_NAME"
  public let linkRunner = >-"cp .build/release/$ROCKET_SPEC_NAME $ROCKSET_PATH/bin"
  public let cleanRunner = >-"rm -rf .build"

  
  public init(
    rockPath: Path = Path(ProcessInfo.processInfo.environment["ROCK_PATH"] ?? "~/.rock").absolute(),
    shellEnv: [String: String] = ProcessInfo.processInfo.environment
  ) {
    self.rockPath = rockPath
    self.shellEnv = shellEnv.updatingValue(rockPath.description, forKey: "ROCK_PATH")
  }
  
  public var rockSetsPath: Path {
    return rockPath + "rocksets"
  }
  
  public var rockSpecsPath: Path {
    return rockPath + "rockspecs"
  }
}
