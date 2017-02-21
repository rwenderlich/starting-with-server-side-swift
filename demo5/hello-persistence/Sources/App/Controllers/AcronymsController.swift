import Vapor
import HTTP

final class AcronymsController: ResourceRepresentable {

  func index(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.all().makeNode())
  }
  
  func create(request: Request) throws -> ResponseRepresentable {
    var acronym = try request.acronym()
    try acronym.save()
    return acronym
  }
  
  func show(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
    return acronym
  }
  
  func update(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
    let new = try request.acronym()
    var acronym = acronym
    acronym.short = new.short
    acronym.long = new.long
    try acronym.save()
    return acronym
  }
  
  func delete(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
    try acronym.delete()
    return JSON([:])
  }

  func makeResource() -> Resource<Acronym> {
    return Resource(
      index: index,
      store: create,
      show: show,
      modify: update,
      destroy: delete
    )
  }

}

extension Request {
  func acronym() throws -> Acronym {
    guard let json = json else { throw Abort.badRequest }
    return try Acronym(node: json)
  }
}
