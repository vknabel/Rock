import Foundation
import PromptLine
import PathKit

public enum RockError: Error {
  case notImplemented(String)
  
  case rockfileMustContainDictionary
  case rockfileMustHaveAName
  case rockfileMustHaveDependencies
  case rockfileHasInvalidDependency
  case rockfileIsNotValidYaml(String?)
  case rockfileCouldNotBeRead(Path, Error)
  
  case couldNotCreateSourcesDirectory(PromptError)

  case specsJsonHasInvalidFormat
  case specsJsonHasNoName
  case specsJsonHasNoUrl(name: String)

  case rocketsCouldNotBeUninstalled(Error)
  
  case allSpecsCouldNotBeDetermined

  case rocketBinaryCouldNotBeUnlinked(RocketSpec)

  case rocketSourceCouldNotBeCloned(RocketSpec, PromptError)
  case rocketSourceCouldNotBeUpdated(RocketSpec, PromptError)
  case rocketSourceCouldNotBeFetched(RocketSpec, PromptError)

  case specsRepoNotFound(name: String)
  case specsRepoCouldNotBeUpdated(RockSpec, PromptError)
  case specsRepoCouldNotBeCloned(RockSpec, PromptError)

  case rocketSpecIsNotValidYaml(String?)
  case rocketSpecCouldNotBeRead(Path, Error)
  case rocketSpecRequiresAnUrl(name: String)
  case rocketSpecCouldNotBeFound(name: String)
  case rocketSpecCouldNotBeBuilt(PromptError)
  case rocketSpecCouldNotBeLinked(PromptError)
  case rocketSpecCouldNotBeUnlinked(PromptError)
  case rocketSpecCouldNotBeCleaned(PromptError)
}
