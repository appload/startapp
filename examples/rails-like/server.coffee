Startapp = require "../../lib/startapp"

Main = require "./controllers/main"
Users = require "./controllers/users"

class Router extends Startapp
  
  @get "/", Main, "index"
  @resource "/users", Users

Router.listen()