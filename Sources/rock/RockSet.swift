//
//  RockSet.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit

struct RockSet {
  static let defaultSet: RockSet = RockSet(name: "global")
  
  var name: String
  
  var path: Path {
    return RockEnv.rockSets + name
  }
  
  var rockets: Path {
    return path + "rockets"
  }
  
  var binaries: Path {
    return path + "bin"
  }
  
  func prepare() throws -> Void {
    try rockets.mkpath()
    try binaries.mkpath()
  }
}
