import Vapor
import VaporPostgreSQL

let drop = Droplet(
  preparations: [Acronym.self],
  providers: [VaporPostgreSQL.Provider.self]
)

drop.get("version") { request in
  if let db = drop.database?.driver as? PostgreSQLDriver {
    let version = try db.raw("SELECT version()")
    return try JSON(node: version)
  } else {
    return "No db connection"
  }
}

drop.get("model") { request in
  let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
  return try acronym.makeJSON()
}

drop.get("test") { request in
  var acronym = Acronym(short: "AFK", long: "Away From Keyboard")
  try acronym.save()
  return try JSON(node: Acronym.all().makeNode())
}

drop.post("new") { request in
  var acronym = try Acronym(node: request.json)
  try acronym.save()
  return acronym
}

drop.get("all") { request in
  return try JSON(node: Acronym.all().makeNode())
}

drop.get("first") { request in
  return try JSON(node: Acronym.query().first()?.makeNode())
}

drop.get("afks") { request in
  return try JSON(node: Acronym.query().filter("short", "AFK").all().makeNode())
}

drop.get("not-afks") { request in
  return try JSON(node: Acronym.query().filter("short", .notEquals, "AFK").all().makeNode())
}

drop.get("update") { request in

  guard var first = try Acronym.query().first(),
    let long = request.data["long"]?.string else {
    throw Abort.badRequest
  }
  first.long = long
  try first.save()
  return first

}

drop.get("delete-afks") { request in
  let query = try Acronym.query().filter("short", "AFK")
  try query.delete()
  return try JSON(node: Acronym.all().makeNode())
}








drop.run()
