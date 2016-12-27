
public struct RocketSrc {
  public let set: RockSet
  public let spec: RocketSpec

  public init(set: RockSet, spec: RocketSpec) {
    self.set = set
    self.spec = spec
  }
}

import PathKit

public extension RocketSrc {
  public var path: Path {
    return set.rockets + spec.name
  }
}
