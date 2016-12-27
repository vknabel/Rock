
public struct RocketBin {
  public let set: RockSet
  public let spec: RocketSpec

  public init(set: RockSet, spec: RocketSpec) {
    self.set = set
    self.spec = spec
  }
}

import PathKit

public extension RocketBin {
  public var path: Path {
    return set.binaries + spec.name
  }
}
