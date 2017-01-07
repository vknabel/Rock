import PackageDescription

let package = Package(
  name: "Rock",
  targets: [
    Target(name: "rock", dependencies: ["RockLib"]),
    Target(name: "RockLib", dependencies: []),
  ],
  dependencies: [
    .Package(url: "https://github.com/kylef/PathKit.git", Version(0, 7, 1)),
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0, minor: 11),
    .Package(url: "https://github.com/vknabel/Swiftline.git", majorVersion: 0, minor: 5),
    .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3, minor: 3),
    .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3),
    .Package(url: "https://github.com/vknabel/Lens.git", majorVersion: 0, minor: 1),
    .Package(url: "https://github.com/vknabel/PromptLine.git", majorVersion: 0, minor: 3),
  ]
)
