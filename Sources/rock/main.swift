import Foundation
import PathKit
import Swiftline
import Yaml
import RockLib
import Commandant
import Result
import PromptLine

extension RocketSpec: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "RocketSpec(name: \(name.debugDescription), url: \(url.debugDescription))"
  }
}

// # global install with rocket, otherwise local
// % rock install [--project path] | [rocket[@tag-or-version]]*
// # global update with rocket, otherwise local
// % rock update [--project path] [rocket[@tag-or-version]]*
// % rock self-update // no: rock install rock
// % rock uninstall [rocket]*
// % rock search [--project path] [rocket]

infix operator <*> : LogicalDisjunctionPrecedence
infix operator % : MultiplicationPrecedence
infix operator <| : MultiplicationPrecedence

let main = CommandRegistry<RockError>()
main.register(InstallCommand())
main.register(UninstallCommand())
main.register(InitCommand())
main.register(VersionCommand())
main.register(RunCommand())
main.register(ScriptCommand(
  verb: "build",
  defaultScript: RockConfig.rockConfig.debugBuildScript,
  function: "Executes the script defined in Rockfile named build."
))
main.register(ScriptCommand(
  verb: "test",
  defaultScript: RockConfig.rockConfig.testScript,
  function: "Executes the script defined in Rockfile named test."
))
main.register(ScriptCommand(
  verb: "archive",
  defaultScript: RockConfig.rockConfig.archiveScript,
  function: "Executes the script defined in Rockfile named archive."
))
main.register(HelpCommand(registry: main))

main.main(defaultVerb: "help") { error in
  let reporter: PromptReporter = report("\(error)", format: .error)
  _ = reporter(Prompt())
}
