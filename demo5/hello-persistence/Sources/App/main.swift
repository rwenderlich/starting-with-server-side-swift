import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

(drop.view as? LeafRenderer)?.stem.cache = nil

let basic = BasicController()
basic.addRoutes(drop: drop)

let acronyms = AcronymsController()
drop.resource("acronyms", acronyms)

let controller = TILController()
controller.addRoutes(drop: drop)

drop.run()
