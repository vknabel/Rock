//
//  RocketSpec.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import Yaml
import RockLib

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

extension RocketSpec {
  init(named name: String, yaml: Yaml) throws {
    guard let url = yaml["url"].string else { throw RocketSpecError.urlRequired(name) }
    self.init(
      name: name,
      url: url,
      branch: yaml["branch"].string,
      install: yaml["install"].stringArray ?? [],
      uninstall: yaml["uninstall"].stringArray ?? [],
      clean: yaml["clean"].stringArray ?? []
    )
  }
}
