import PathKit

public struct RockSpec {
  public var name: String
  public var url: String

  public init(name: String = "global", url: String = "https://github.com/vknabel/RockSpecs") {
    self.name = name
    self.url = url
  }

  public var path: Path {
    return RockConfig.rockConfig.rockSpecsPath + name
  }

  public var specsPath: Path {
    return path + "Specs"
  }
}
