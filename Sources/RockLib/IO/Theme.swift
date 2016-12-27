import Swiftline

public extension CustomStringConvertible {
  public var theme: ThemedString {
    return ThemedString(string: self.description)
  }
}

public struct ThemedString {
  fileprivate var string: String
  
  public var coded: String {
    return string.foreground.Magenta
  }
  
  public var input: String {
    return string.foreground.Blue
  }
  
  public var derived: String {
    return string.foreground.Cyan
  }
  
  public var error: String {
    return string.foreground.Red
  }
  
  public var warn: String {
    return string.foreground.Yellow
  }
}
