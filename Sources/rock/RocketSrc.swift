//
//  RocketSrc.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit
import Swiftline
import RockLib

extension RocketSrc {
  func clone(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Cloning \(spec.name.f.Blue)")
    let result = run("git", args: ["clone", "--depth", "1", spec.url, path.description], settings: {
      //$0.interactive = true
      settings?($0)
    })
    guard result.exitStatus == 0 else { throw result }
  }

  func fetch(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Fetching \(spec.name.f.Blue)")
    let result = run("git", args: ["fetch", "--tags"], settings: {
      //$0.interactive = true
      settings?($0)
    })
    guard result.exitStatus == 0 else { throw result }
  }

  func update(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Updating \(spec.name.f.Blue)")
    let result = run("git", args: ["pull"], settings: {
      //$0.interactive = true
      settings?($0)
    })
    guard result.exitStatus == 0 else { throw result }
  }

  func maybeSwiftenvInstall() throws -> Void {
    try path.chdir {
      print("👉 Checking swift version")
      let version = run("swiftenv version")
      print("👉 \(spec.name.f.Blue) requires Swift \(version.stdout.f.Blue)")
      let result = run("swift --version")
      guard result.exitStatus == 0 else { throw result }
    }
  }

  func agreeSwiftenvInstall() throws -> Void {
    print("⚠️ Swift not found")
    let version = run("swiftenv version")
    guard agree("❓ \(spec.name.f.Blue) requires swift \(version.stdout.f.Blue), which is not installed. Shall it be installed using swiftenv? (y/n)") else { return }
    try swiftenvInstall()
  }

  func swiftenvInstall() throws -> Void {
    try path.chdir {
      print("👉 Installing new swift version. This may take a while...")
      let result = run("swiftenv install")
      guard result.exitStatus == 0 else { throw result }
    }
  }

  private func runLocal(_ commands: [String], settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    try path.chdir {
      try commands.forEach {
        let command = $0.replacingOccurrences(of: "$ROCKSET_PATH", with: set.path.description)
          .replacingOccurrences(of: "$ROCKET_SPEC_NAME", with: spec.name)
        print("🏃", command)
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = command.components(separatedBy: " ")
        process.launch()
        process.waitUntilExit()
        //dump(result)
        //guard process.terminationStatus == 0 else { throw result }
      }
    }
  }

  func install(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Installing \(spec.name.f.Blue)")
    try runLocal(spec.installShell, settings: settings)
  }

  func uninstall(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Uninstalling \(spec.name.f.Blue)")
    try runLocal(spec.uninstallShell, settings: settings)
    try path.delete()
  }

  func clean(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    print("👉 Cleaning \(spec.name.f.Blue)")
    try runLocal(spec.cleanShell, settings: settings)
  }

  func preferredVersion(settings: ((RunSettings) -> Void)? = nil) throws -> String {
    // versions()
    return "master"
  }

  func checkout(version: String, settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    try runLocal(["git checkout \"\(version)\""], settings: settings)
  }
}
