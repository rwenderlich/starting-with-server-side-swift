## Demo 1

I’ve already installed Xcode 8 and the vapor toolbox, so I'll create a project with Vapor, by runining run vapor new. I'll call this project hello-vapor, and switch to the newly created directory.

Vapor is built on top of the Swift package manager, so U could build it using swift build, or through vapor build, or through vapor build, which is a wrapper around that, but personally I find it easier to work with an Xcode project - that way I can see all my files and use auto-completion, which once you get used to it is hard to live without. To create a new Xcode project file, I'll simply run vapor xcode.

```
vapor new hello-vapor
cd hello-vapor
vapor xcode
```

Note it takes a while to generate the Xcode project - and even longer to build - so rather than having you all wait for it to build, I’m going to switch over to another directory that is pre-built and run that one instead.

To build it, I need to switch to the app target, then build and run. Note that the web server runs by default on port 8080, so I'll open up a web browser - and nice, it works!

```
http://localhost:8080/
```

## Demo 2

```
import Vapor

let drop = Droplet()

drop.get { request in
  return "Hello, Vapor!"
}

drop.run()
```

```
drop.get { req in
  // return "Hello, Vapor!"
  return try JSON(node: [
    "message": "Hello, Vapor!"
  ])
}
```

```
drop.get("hello") { request in
  return try JSON(node: [
    "message": "Hello, again!"
  ])
}
```

```
drop.get("hello", "there") { request in
  return try JSON(node: [
    "message": "I am tired of saying hello!"
  ])
}
```

```
drop.get("beers", Int.self) { request, beers in
  return try JSON(node: [
    "message": "Take one down, pass it around, \(beers - 1) bottles of beer on the wall..."
  ])
}
```

```
drop.post("post") { request in
  guard let name = request.data["name"]?.string else {
    throw Abort.badRequest
  }
  return try JSON(node: [
    "message": "Hello, \(name)!"
  ])
}
```