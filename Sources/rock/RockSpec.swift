//
//  RockSpec.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit
import Swiftline
import Yaml
import RockLib

enum RockError: Error {
  case rethrow(String, String?)
  case report(String)

  static func wrap<T>(_ closure: @autoclosure () throws -> T, _ annotation: String? = nil) throws -> T {
    do {
      return try closure()
    } catch {
      throw RockError.rethrow(error.localizedDescription, annotation)
    }
  }
}

extension RunResults: Error { }

extension RockSpec {
  func prepare(settings: ((RunSettings) -> Void)? = nil) throws -> Void {
    try path.parent().mkpath()
    if path.exists {
      try update(settings: settings)
    } else {
      try RockError.wrap(clone(settings: settings), "Preparing RockSpec \(name.f.Blue) with origin \(url.f.Blue)")
    }
  }

  private func path(for specName: String) -> Path {
    return specs + (specName + ".yaml")
  }

  func spec(named name: String) throws -> RocketSpec {
    let specPath = path(for: name)
    let contents: String = try specPath.read()
    let yaml = try Yaml.load(contents)
    return try RocketSpec(named: name, yaml: yaml)
  }

  func specNames() throws -> [String] {
    return try specs.children()
      .filter({ $0.isFile })
      .map({ $0.lastComponentWithoutExtension })
  }

  func list() throws -> Void {
    try specNames().forEach({ print($0) })
  }

  func addSpec(name: String, url: String, branch: String? = nil, install: [String] = [], uninstall: [String] = [], clean: [String] = []) throws -> RocketSpec {
    func serialize(shell: [String], name: String) -> String {
      guard shell.count != 0 else {
        return ""
      }
      return shell.reduce("\n\(name):") {
        $0 + "\n- " + $1
      }
    }

    let output = "url: \(url)"
      + (branch ?? "")
      + serialize(shell: install, name: "install")
      + serialize(shell: uninstall, name: "uninstall")
      + serialize(shell: clean, name: "clean")

    let spec = RocketSpec(name: name, url: url, branch: branch, install: install, uninstall: uninstall, clean: clean)
    let path = self.path(for: name)
    try RockError.wrap(path.parent().mkpath(), "while creating path \(path.parent().description.f.Blue) for new RockSpec \(self.name.f.Blue) to path \(path.description.f.Blue)")
    try RockError.wrap(path.write(output), "while writing out new RocketSpec \(name.f.Blue) for RockSpec \(self.name.f.Blue) to path \(path.description.f.Blue)")
    return spec
  }
}

extension RockSpec {
  init(dictionary: [String: Any]) throws {
    guard let name = dictionary["name"] as? String else {
      throw RockError.report("Record for RockSpec has no name.")
    }
    guard let url = dictionary["url"] as? String else {
      throw RockError.report("Record for RockSpec named \(name.f.Blue) has no url")
    }
    self.name = name
    self.url = url
  }

  static func allSpecs() throws -> [RockSpec] {
    let specsRecordPath = RockEnv.rockSpecs + "specs.json"
    if !specsRecordPath.exists {
      try RockError.wrap(specsRecordPath.parent().mkpath(), "while creating specs directory")
      let defaultSpec = [
        ["name": "local", "url": ""],
        ["name": "default", "url": "https://github.com/vknabel/RockSpecs"]
      ]
      let data = try! JSONSerialization.data(withJSONObject: defaultSpec, options: .prettyPrinted) // would be a dev error
      try RockError.wrap(specsRecordPath.write(data), "while writing default RockSpec records \(specsRecordPath.description.f.Magenta)")
    }
    let specsRecord = try RockError.wrap(JSONSerialization.jsonObject(with: try specsRecordPath.read(), options: []), "while reading the RockSpec records \(specsRecordPath.description.f.Magenta)")
    guard let records = specsRecord as? [[String: Any]] else {
      throw RockError.report("The RockSpec record file \(specsRecordPath.description.f.Magenta) needs to contain a list of (name: String, url: String).")
    }
    return try RockError.wrap(records.map(RockSpec.init(dictionary:)), "while parsing the RockSpec records \(specsRecordPath.description.f.Magenta)")
  }
}
