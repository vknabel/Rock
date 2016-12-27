import Foundation
import PromptLine

public enum RockError: Error {
  case rocketBinaryCouldNotBeUnlinked(RocketBin)
  
  case rocketSourceCouldNotBeCloned(RocketSrc, PromptError)
  case rocketSourceCouldNotBeUpdated(RocketSrc, PromptError)
  case rocketSourceCouldNotBeFetched(RocketSrc, PromptError)
  
  case specsRepoNotFound(name: String)
  case specsRepoCouldNotBeUpdated(RockSpec, PromptError)
  case specsRepoCouldNotBeCloned(RockSpec, PromptError)
  
  case specCouldNotBeBuilt(PromptError)
  case specCouldNotBeLinked(PromptError)
  case specCouldNotBeUnlinked(PromptError)
  case specCouldNotBeCleaned(PromptError)
}
