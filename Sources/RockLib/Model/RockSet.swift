
public struct RockSet {
  public static let defaultSet: RockSet = RockSet(name: "global")

  public var name: String

  public init(name: String) {
    self.name = name
  }
}

import PathKit

public extension RockSet {
  public var path: Path {
    return RockConfig.rockConfig.rockSetsPath + name
  }

  public var rockets: Path {
    return path + "rockets"
  }

  public var binaries: Path {
    return path + "bin"
  }
}
