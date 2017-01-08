func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { first in { second in function(first, second) } }
}
