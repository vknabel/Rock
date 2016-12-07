//
//  RocketBin.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit

struct RocketBin {
  let set: RockSet
  let spec: RocketSpec
  
  var path: Path {
    return set.binaries + spec.name
  }
  
  func unlink() throws -> Void {
    try path.delete()
  }
}
