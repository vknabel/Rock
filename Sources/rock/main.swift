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
// % rock self-update
// % rock uninstall [--project path] [rocket]*
// % rock search [--project path] [rocket]
// % rock run [--project path] %@

infix operator <*> : LogicalDisjunctionPrecedence
infix operator % : MultiplicationPrecedence
infix operator <| : MultiplicationPrecedence

let main = CommandRegistry<RockError>()
main.register(InstallCommand())
main.register(HelpCommand(registry: main))

main.main(defaultVerb: "help") { error in
  let reporter: PromptReporter = report("\(error)", format: .error)
  _ = reporter(Prompt())
}
