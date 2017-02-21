import Vapor
import HTTP
import VaporPostgreSQL

final class BasicController {

  func addRoutes(drop: Droplet) {
    let basic = drop.grouped("basic")
    basic.get("version", handler: version)
    basic.get("model", handler: model)
    basic.get("test", handler: test)
    basic.post("new", handler: new)
    basic.get("all", handler: all)
    basic.get("first", handler: first)
    basic.get("afks", handler: afks)
    basic.get("not-afks", handler: notAfks)
    basic.get("update", handler: update)
    basic.get("delete-afks", handler: deleteAfks)
  }

  func version(request: Request) throws -> ResponseRepresentable {
    if let db = drop.database?.driver as? PostgreSQLDriver {
      let version = try db.raw("SELECT version()")
      return try JSON(node: version)
    } else {
      return "No db connection"
    }
  }
  
  func model(request: Request) throws -> ResponseRepresentable {
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    return try acronym.makeJSON()
  }
  
  func test(request: Request) throws -> ResponseRepresentable {
    var acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    try acronym.save()
    return try JSON(node: Acronym.all().makeNode())
  }

  func new(request: Request) throws -> ResponseRepresentable {
    var acronym = try Acronym(node: request.json)
    try acronym.save()
    return acronym
  }

  func all(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.all().makeNode())
  }

  func first(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.query().first()?.makeNode())
  }

  func afks(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.query().filter("short", "AFK").all().makeNode())
  }

  func notAfks(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.query().filter("short", .notEquals, "AFK").all().makeNode())
  }

  func update(request: Request) throws -> ResponseRepresentable {
    guard var first = try Acronym.query().first(),
      let long = request.data["long"]?.string else {
      throw Abort.badRequest
    }
    first.long = long
    try first.save()
    return first

  }

  func deleteAfks(request: Request) throws -> ResponseRepresentable {
    let query = try Acronym.query().filter("short", "AFK")
    try query.delete()
    return try JSON(node: Acronym.all().makeNode())
  }

}
