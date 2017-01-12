import Foundation
import PromptLine
import PathKit
import Result

/// ```
/// ~
/// ├── .rock <-- rockPath = $ROCK_PATH
/// │   ├── bin
/// │   ├── sources
/// │   └── specs
/// └── Project <-- projectPath = $(pwd)
///     ├── Rockfile.yaml
///     └── .rock
///         ├── bin
///         └── sources
/// ```
public struct RockConfig {
  internal static let rockPathEnvVar: String = "ROCK_PATH"
  public static let rockConfig = RockConfig()

  public let rockPath: Path

  public let archiveScript = ["swift build -c release"]
  public let debugBuildScript = ["swift build"]
  public let testScript = ["swift test"]
  public let unlinkScript = ["rm -f $ROCK_PATH/bin/$ROCKET_SPEC_NAME"]
  public let linkScript = ["cp .build/release/$ROCKET_SPEC_NAME $ROCK_PATH/bin"]
  public let cleanScript = ["rm -rf .build"]

  public init(
    rockPath: Path = Path(ProcessInfo.processInfo.environment["ROCK_PATH"] ?? "~/.rock").absolute()
  ) {
    self.rockPath = rockPath
  }

  public var rockSpecsPath: Path {
    return rockPath + "specs"
  }
}
