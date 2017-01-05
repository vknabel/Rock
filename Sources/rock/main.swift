import Foundation
import PathKit
import Swiftline
import Yaml
import RockLib
import Commandant
import Result
import PromptLine

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
main.register(HelpCommand(registry: main))

main.main(defaultVerb: "help") { error in
  let reporter: PromptReporter = report("\(error)", format: .error)
  _ = reporter(Prompt())
}
