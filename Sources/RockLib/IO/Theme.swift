import ColorizeSwift

public extension CustomStringConvertible {
  public var theme: ThemedString {
    return ThemedString(string: self.description)
  }
}

public struct ThemedString {
  fileprivate var string: String

  public var coded: String {
    return string.magenta()
  }

  public var input: String {
    return string.blue()
  }

  public var derived: String {
    return string.cyan()
  }

  public var error: String {
    return string.red()
  }

  public var warn: String {
    return string.yellow()
  }
}
