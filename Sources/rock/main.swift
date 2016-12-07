//
//  main.swift
//  Rock
//
//  Created by Valentin Knabel on 06.12.16.
//
//

import Foundation
import PathKit
import Swiftline
import Yaml

class Lazy<T> {
  private let raw: () -> T
  lazy var value: T = self.raw()
  
  init(_ value: @escaping () -> T) {
    raw = value
  }
}

final class Rock {
  let rockSet: RockSet = RockSet.defaultSet
  let rockSpecs: [RockSpec]
  let settings: (RunSettings) -> Void = { settings in
    //settings.echo = [.Stdout, .Stderr, .Command]
    //settings.interactive = true
  }

  init() throws {
    rockSpecs = try! RockSpec.allSpecs()
  }
  
  var sources: [String: RocketSrc] = [:]

  func source(named name: String) throws -> RocketSrc {
    if let src = sources[name] {
      return src
    } else {
      let lazyRocketSpecs: [Lazy<RocketSpec?>] = rockSpecs.map({ rockSpec in
        Lazy<RocketSpec?> { try? rockSpec.spec(named: name) }
      })
      let match = lazyRocketSpecs.first(where: { (lazySpec: Lazy<RocketSpec?>) -> Bool in
        lazySpec.value != nil
      }).flatMap { $0.value }

      guard let spec = match else {
        throw RockError.report("RocketSpec \(name.f.Blue) not found.")
      }
      let src = RocketSrc(set: rockSet, spec: spec)
      sources[name] = src
      return src
    }
  }

  func prepare() -> Void {
    try! rockSet.prepare()
    try! rockSpecs.forEach { try $0.prepare(settings: settings) } // on error: proceed
  }

  func install(name: String) -> Void {
    let src = try! source(named: name)
    try? src.clone(settings: settings)
    try! src.maybeSwiftenvInstall()
    try! src.install(settings: settings)
    print("✅ Successfully installed \(name.f.Blue) 🚀!")
  }

  func update(name: String) -> Void {
    let src = try! source(named: name)
    try! src.update(settings: settings)
    try! src.maybeSwiftenvInstall()
    try! src.install(settings: settings)
  }

  func uninstall(name: String) -> Void {
    let src = try! source(named: name)
    try! src.uninstall(settings: settings)
    try! src.clean(settings: settings)
  }

  func clean(name: String) -> Void {
    let src = try! source(named: name)
    try! src.clean(settings: settings)
  }

  func reinstall(name: String) -> Void {
    uninstall(name: name)
    install(name: name)
  }
  
  func listRocketSpecs(named name: String) throws -> Void {
    guard let spec = rockSpecs.first(where: { $0.name == name }) else {
      throw RockError.report("There is no RockSpec \(name.f.Blue)")
    }
    try! spec.list()
  }

  func listRockSpecs() -> Void {
    rockSpecs.map({ $0.name }).forEach {
      print($0)
    }
  }
  func specAdd(url: String, defaultScripts: Bool) throws -> RocketSpec {
    guard let local = rockSpecs.first(where: { $0.name == "local" }) else {
      throw RockError.report("There is no RockSpec with name \("local".f.Blue)")
    }
    
    let nameDefault = (url.components(separatedBy: "/").last ?? url).lowercased()
    var name = nameDefault
    var installs: [String] = []
    var uninstalls: [String] = []
    var cleans: [String] = []
    
    if !defaultScripts {
      name = ask("❓ Name of the target to be linked? [\(nameDefault.f.Blue)]") { settings in
        settings.defaultValue = nameDefault
      }
      if name.isEmpty {
        name = nameDefault
      }
      
      installs = ask("❓ How to install the project? [\("swift build".f.Magenta)]").components(separatedBy: ";")
      uninstalls = ask("❓ How to uninstall the project? [\("rm".f.Magenta)]").components(separatedBy: ";")
      cleans = ask("❓ How to clean the project? [\("rm .build".f.Magenta)]").components(separatedBy: ";")
    }
    return try! local.addSpec(name: name, url: url, install: installs, uninstall: uninstalls, clean: cleans)
  }
  
  /*func list() -> Void {
    try! rockSpec.list()
  }*/
}

import Commander

let main = Group {
  let rock = try! Rock()
  rock.prepare()

  let installCommand = command(VariadicArgument<String>("rocket name"), { $0.forEach(rock.install) })
  $0.addCommand("install", "Installs given 🚀s by name.", installCommand)

  let updateCommand = command(VariadicArgument<String>("rocket name"), { $0.forEach(rock.update) })
  $0.addCommand("update", "Updates given 🚀s by name.", updateCommand)

  let selfUpdateCommand = command { rock.update(name: "rock") }
  $0.addCommand("self-update", "Self-updates rock.", selfUpdateCommand)

  let uninstallCommand = command(VariadicArgument<String>("rocket name"), { $0.forEach(rock.uninstall) })
  $0.addCommand("uninstall", "Uninstalls given 🚀s by name.", uninstallCommand)

  let reinstallCommand = command(VariadicArgument<String>("rocket name"), { $0.forEach(rock.reinstall) })
  $0.addCommand("reinstall", "Reinstalls a given 🚀s by name.", reinstallCommand)

  let cleanCommand = command(VariadicArgument<String>("rocket name"), { $0.forEach(rock.clean) })
  $0.addCommand("clean", "Cleans given 🚀s by name.", cleanCommand)

  /*let listCommand = command(rock.list)
  $0.addCommand("list", listCommand)*/
  
  $0.group("spec") {
    let addCommand = command(
      Flag("install", description: "Directly installs the created RocketSpec"),
      Flag("default", description: "Uses all default scripts."),
      Argument<String>("rocket spec url")
    ) { installFlag, defaultScriptsFlag, rawUrl in
      let url: String
      if URL(string: rawUrl) == nil {
        url = "https://github.com/\(rawUrl)"
      } else {
        url = rawUrl
      }
      let spec = try! rock.specAdd(url: url, defaultScripts: defaultScriptsFlag)
      if installFlag {
        rock.install(name: spec.name)
      }
    }
    $0.addCommand("add", "Adds a new RocketSpec to the RockSpec", addCommand)
    
    let rocketsCommand = command(
      Argument<String>("rock spec name"),
      rock.listRocketSpecs
    )
    $0.addCommand("rockets", "Lists all RocketSpecs of a RockSpec", rocketsCommand)
    
    let listCommand = command(
      rock.listRockSpecs
    )
    $0.addCommand("list", "Lists all RockSpecs", listCommand)
  }
}

main.run("0.1.0")
