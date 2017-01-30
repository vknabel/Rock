// Generated using Sourcery 0.5.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation

let rockPath = ProcessInfo.processInfo.environment["ROCK_PATH"] ?? "~/.rock"
let version = ProcessInfo.processInfo.environment["ROCK_VERSION"] ?? "0.2.2"

func run(workingDir: String? = nil, _ args: String...) {
  let process = Process()
  process.launchPath = "/usr/bin/env"
  process.currentDirectoryPath = workingDir ?? process.currentDirectoryPath
  process.arguments = args
  process.launch()
  process.waitUntilExit()
}

let wd = "\(rockPath)/sources/rock/"
run(
  "git", "clone",
  "https://github.com/vknabel/Rock",
  wd,
  "--depth", "1",
  "--branch", version
)
run(workingDir: wd, "swift", "build", "-c", "release")
run("mkdir", "-p", "\(rockPath)/bin")
run("cp", "\(rockPath)/sources/rock/.build/release/rock", "\(rockPath)/bin")

print("\n\nDon't forget to add $PATH and $ROCK_PATH to your profile:")
print("   export ROCK_PATH=\"$HOME/.rock\"")
print("   export PATH=\"$PATH:./.rock/bin:$ROCK_PATH/bin\"")
