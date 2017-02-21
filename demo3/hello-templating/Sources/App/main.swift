import Vapor

let drop = Droplet()

drop.get("template1") { request in
  return try drop.view.make("hello", Node(node: ["name": "Ray"]))
}

drop.get("template2", String.self) { request, name in
  return try drop.view.make("hello", Node(node: ["name": name]))
}

drop.get("template3") { request in
  let users = try ["Ray", "Vicki", "Brian"].makeNode()
  return try drop.view.make("hello2", Node(node: ["users": users]))
}

drop.get("template4") { request in
  let users = try [
    ["name": "Ray", "email": "ray@razeware.com"].makeNode(),
    ["name": "Vicki", "email": "vicki@razeware.com"].makeNode(),
    ["name": "Brian", "email": "brian@razeware.com"].makeNode()
  ].makeNode()
  return try drop.view.make("hello3", Node(node: ["users": users]))
}

drop.get("template5") { request in
  guard let sayHello = request.data["sayHello"]?.bool else {
    throw Abort.badRequest
  }
  return try drop.view.make("hello4", Node(node: ["sayHello": sayHello.makeNode()]))
}

drop.run()
