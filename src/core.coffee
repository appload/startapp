express = require("express")
_ = require("underscore")

class StartappCore
  
  constructor: (@req, @res, @next) ->
  
  @environment: (app) ->
  
  @set_routes: (prefix, app) ->
    for [method, path, controller, action] in @_routes
      if method is "mount"
        controller.set_routes prefix + path, app
      else
        unless action?
          [controller, action] = [@, controller]
        if path == "/" and prefix != "" then path = ""
        app[method](prefix + path, controller.action(action))
  
  @action: (name) ->
    (req, res, next) =>
      controller = new @(req, res, next)
      if typeof name is "function"
        name.call(controller)
      else if controller[name]?
        controller[name]()
      else
        next()
  
  @mixin: (obj) ->
    for key, val of obj
      @::[key] = val
  
  for method in ["get", "post", "put", "del", "mount"]
    do (method) =>
      @[method] = (args...) ->
        @_routes = (route for route in @_routes or []) # copy of existing route array
        @_routes.push [method, args...]
  
  @listen: (port = 3000) ->
    app = express.createServer()
    @environment(app)
    @set_routes("", app)
    app.listen port

module.exports = StartappCore