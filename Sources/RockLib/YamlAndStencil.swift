import Foundation
import PathKit
import Stencil
import Yaml

private extension String {
  func render(_ context: Context? = nil) throws -> String {
    let template = Template(templateString: self)
    return try template.render(context)
  }
}
private func sortDescriptor(by order: [Yaml]) -> Yaml.YamlSortDescriptor {
  func priority(_ yaml: Yaml) -> Int? {
    return order.index(of: yaml)
  }
  return { (lhs: (Yaml, Yaml), rhs: (Yaml, Yaml)) -> Bool in
    switch (priority(lhs.0), priority(rhs.0)) {
    case let (.some(lhs), .some(rhs)):
      return lhs < rhs
    case (.some(_), _):
      return true
    case (_, .some(_)):
      return false
    default:
      return true
    }
  }
}

private extension Yaml {
  /// Dict: only strings
  var rawValue: Any {
    switch self {
    case .null:
            return ()
    case let .bool(value):
            return value
    case let .int(value):
            return value
    case let .double(value):
            return value
    case let .string(value):
            return value
    case let .array(value):
            return value.map { $0.rawValue }
    case let .dictionary(dict):
      var rawDict = [String: Any]()
      for (key, value) in dict {
        guard let key = key.string else { continue }
        rawDict[key] = value.rawValue
      }
      return rawDict
    }
  }

  func render(
    _ dictionary: [String: Any],
    namespace: Namespace = Namespace(),
    descriptor: Yaml.YamlSortDescriptor
  ) throws -> (Any, Yaml) {
    switch self {
    case let .string(value):
      let context = Context(dictionary: dictionary, namespace: namespace)
      let rendered = try value.render(context)
      return (rendered, .string(rendered))
    case let .array(values):
      var contextList = [Any]()
      var vs = [(Any, Yaml)]()
      for v in values {
        let result = try v.render(dictionary, namespace: namespace, descriptor: descriptor)
        contextList.append(result.0)
        vs.append(result)
      }
      return (vs.map { $0.0 }, .array(vs.map { $0.1 }))
    case let .dictionary(value):
      var dict = [Yaml: Yaml]()
      var dictionary = dictionary
      var localDictionary: [String: Any] = [:]

      try value.sorted(by: descriptor).forEach { key, value in
        let renderedKey = try key.render(dictionary, namespace: namespace, descriptor: descriptor)
        let renderedValue = try value.render(dictionary, namespace: namespace, descriptor: descriptor)
        dict[renderedKey.1] = renderedValue.1

        if let renderedKey = renderedKey.0 as? String {
          localDictionary[renderedKey] = renderedValue.0
          dictionary[renderedKey] = renderedValue.0
        }
      }
      return (localDictionary, .dictionary(dict))
    default:
      return (self.rawValue, self)
    }
  }
}

public extension Yaml {
  public typealias YamlSortDescriptor = ((Yaml, Yaml), (Yaml, Yaml)) -> Bool

  public static func rendering(
    _ text: String,
    namespace: Namespace = Namespace(),
    orderedBy order: [Yaml] = ["const", "constant", "constants", "version", "license", "name", "url"]
  ) throws -> Yaml {
    return try rendering(text, namespace: namespace, sort: sortDescriptor(by: order))
  }

  public static func rendering(
    _ text: String,
    namespace: Namespace = Namespace(),
    sort descriptor: YamlSortDescriptor
  ) throws -> Yaml {
    return try Yaml.load(text).render([:], namespace: namespace, descriptor: descriptor).1
  }
}
