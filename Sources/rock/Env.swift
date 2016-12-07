//
//  Env.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit

struct RockEnv {
  static let rock: Path = Path(ProcessInfo.processInfo.environment["ROCK_PATH"] ?? "~/.rock").absolute()
  static let rockSets: Path = rock + "rocksets"
  static let rockSpecs: Path = rock + "rockspecs"
  
  static let shellEnv: [String: String] = {
    var env = ProcessInfo.processInfo.environment
    env["ROCK_PATH"] = rock.absolute().description
    return env
  }()
}
