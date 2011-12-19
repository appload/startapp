express = require "express"
_ = require "underscore"

# class StartApp
#   @routes or= []
#   @options = @::options = {}
#   
#   @createServer = ->
#     app = express.createServer()
#     app[method](args...) for [method, args...] in @routes
#     app
#   
#   @listen = (port = 3000) ->
#     app = @createServer()
#     app.listen port
#   
#   @set = (options) ->
#     @options = @::options = _.clone(@options)
#     @options[key] = val for key, val of options
#     
#   for name in "get post put update delete head".split " "
#     do (name) =>
#       @[name] = (path, action) =>
#         handler = if @::[action]? then (req, res, next) =>
#           controller = new @(req, res, next)
#           controller[action]()
#         else (req, res, next) =>
#           res.send "#{@::constructor.name}::#{action} doesn't exist.", 400
#         @routes = _.clone @routes
#         @routes.push [name, path, handler]
# 
#   constructor: (@req, @res, @next) ->

class StartApp
  constructor: (@req, @res, @next) ->
  
  @enhance = (enhancer) ->
    console.log "enhance", enhancer.toString()
    console.log "@build before", @build
    @build = _(@build).clone() or []
    @build.push enhancer
    console.log "@build after", @build
  
  @action = (name) ->
    if typeof @::[name] is "function"
      console.log "@action(#{name})"
      (req, res, next) =>
        controller = new @(req, res, next)
        controller[name].call controller
    else
      message = "#{@::constructor.name}::#{name} doesn't exist."
      console.error message
      (req, res, next) ->
        res.send message, 400
        
  for method in ["get", "post", "put", "update", "delete"]
    @[method] = (path, action_name) =>
      # if not action?
      #           action = controller
      #           controller = @
      @enhance (app) => app[method] path, @action(action_name)
  
  @use = (middleware) =>
    @enhance (app) -> app.use middleware
  
  @set = (options) ->
    @enhance (app) -> app.set key, val for key, val of options
    
    @options = @::options = _(@options).clone() or {}
    @options[key] = val for key, val of options
  
  @createServer = ->
    app = express.createServer()
    enhancer(app) for enhancer in @build
    app
  
  @listen = (port) ->
    app = @createServer()
    app.listen port
    
  
class App extends StartApp
  @get "/", "index"
  
  @get "/asd", "asd"
  
  @use (req, res, next) -> next()
  
  index: ->
    console.log "index", @
    @res.send "ok"

console.log App.get.toString()
console.log App.build

App.listen 3000