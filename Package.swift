import PackageDescription

let package = Package(
  name: "Rock",
  targets: [
    Target(name: "rock", dependencies: ["RockLib"]),
    Target(name: "RockLib", dependencies: []),
  ],
  dependencies: [
    .Package(url: "https://github.com/kylef/PathKit", Version(0, 7, 1)),
    .Package(url: "https://github.com/kylef/Commander", Version(0, 6, 0)),
    .Package(url: "https://github.com/vknabel/Swiftline", majorVersion: 0, minor: 5),
    .Package(url: "https://github.com/behrang/YamlSwift", majorVersion: 3, minor: 3),
    .Package(url: "https://github.com/antitypical/Result", majorVersion: 3),
    .Package(url: "https://github.com/vknabel/Lens", majorVersion: 0, minor: 1),
    .Package(url: "https://github.com/vknabel/PromptLine", majorVersion: 0, minor: 1),
  ]
)
