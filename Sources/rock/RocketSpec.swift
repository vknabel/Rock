//
//  RocketSpec.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import Yaml

enum RocketSpecError: Error {
  case urlRequired(String)
}

fileprivate extension Yaml {
  var stringArray: [String]? {
    if let s = string {
      return [s]
    } else {
      return array?.flatMap({ $0.string })
    }
  }
}

struct RocketSpec {
  private static let defaultInstall = [
    "swift build -c release",
    "rm -f $ROCKSET_PATH/bin/$ROCKET_SPEC_NAME",
    "cp .build/release/$ROCKET_SPEC_NAME $ROCKSET_PATH/bin"
  ]
  private static let defaultUninstall = ["rm -f $ROCKSET_PATH/bin/$ROCKET_SPEC_NAME"]
  private static let defaultClean = ["rm -rf .build"]
  
  let name: String
  let url: String
  let branch: String? /// tag or branch that won't be recognized by default
  let installShell: [String]
  let uninstallShell: [String]
  let cleanShell: [String]
  
  init(name: String, url: String, branch: String? = nil, install: [String]? = nil, uninstall: [String]? = nil, clean: [String]? = nil) {
    func nilIfEmpty<E: Equatable>(_ array: [E]?) -> [E]? {
      if (array?.count ?? 0) == 0 {
        return nil
      } else {
        return array
      }
    }
    self.name = name
    self.url = url
    self.branch = branch
    self.installShell = nilIfEmpty(install) ?? RocketSpec.defaultInstall
    self.uninstallShell = nilIfEmpty(uninstall) ?? RocketSpec.defaultUninstall
    self.cleanShell = nilIfEmpty(clean) ?? RocketSpec.defaultClean
  }
  
  init(named name: String, yaml: Yaml) throws {
    guard let url = yaml["url"].string else { throw RocketSpecError.urlRequired(name) }
    self.init(
      name: name,
      url: url,
      branch: yaml["branch"].string,
      install: yaml["install"].stringArray,
      uninstall: yaml["uninstall"].stringArray,
      clean: yaml["clean"].stringArray
    )
  }
}
