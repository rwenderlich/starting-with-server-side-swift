import Vapor

final class Acronym: Model {

  var id: Node?
  var exists: Bool = false

  var short: String
  var long: String
  
  init(short: String, long: String) {
    self.id = nil
    self.short = short
    self.long = long
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    short = try node.extract("short")
    long = try node.extract("long")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "short": short,
      "long": long
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("acronyms") { users in
      users.id()
      users.string("short")
      users.string("long")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("acronyms")
  }

}
