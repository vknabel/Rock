import Result
import PromptLine
import PathKit

extension Prompt {
  static func mkpath(_ path: Path) -> PromptRunner<PromptError> {
    return { prompt in Result<Prompt, AnyError>(attempt: {
      try (prompt.workingDirectory + path).mkpath()
      return prompt
    })
      .mapError({ _ in PromptError.termination(reason: .exit, status: 1)})
    }
  }
}

extension Prompt {
  static func cd<E: Error>(_ path: Path, run runner: @escaping PromptRunner<E>) -> PromptRunner<E> {
    return { prompt in
      let oldPath = prompt.workingDirectory
      let wrapped = Prompt.cd(path)
        %& runner
        %& { .success($0.lensWorkingDirectory(to: oldPath)) }
      return wrapped(prompt)
    }
  }
}

public struct Repository {
  public let path: Path
  
  public func create() -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.cd(path, run: >-"git init")
  }
  
  public func clone(url: String) -> PromptRunner<PromptError> {
    return Prompt.cd(
      path.parent(),
      run: >-["git", "clone", "--recursive", "--depth", "1", url, path.description]
    )
  }
  
  public func pull() -> PromptRunner<PromptError> {
    return Prompt.cd(
      path.parent(),
      run: >-"git pull"
    )
  }
  
  public func fetch(tags: Bool = false) -> PromptRunner<PromptError> {
    return Prompt.cd(
      path.parent(),
      run: >-(tags ? "git fetch --tags" : "git fetch")
    )
  }
}
