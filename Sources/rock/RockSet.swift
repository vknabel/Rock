//
//  RockSet.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit
import RockLib

extension RockSet {
  func prepare() throws -> Void {
    try rockets.mkpath()
    try binaries.mkpath()
  }
}
