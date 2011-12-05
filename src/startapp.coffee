express = require("express")
_ = require("underscore")
Cookies = require "cookies"
Keygrip = require "keygrip"
eco = require "eco"

class BlankApp
  
  constructor: (@app) ->
    @environment()
    @routes()
  
  use: (middleware) ->
    @app.use middleware
  
  environment: ->
  
  routes: ->
  
  separator: "."
  
  action: (handler) ->
    if _(handler).isString()
      [controller_name, action_name] = handler.split(@separator)
      if controller_name? and action_name?  
        if controller_class = @get_controller(controller_name)
          controller_class.action(action_name)
        else
          console.warn "Can't find controller #{controller_name} in #{process.cwd()}/controllers/#{controller_name}.(js|coffee)"
      else
        console.warn "Action should be in format: controller#{@separator}action"
    else
      handler
  
  create_handler: (controller_class, action_name) ->
    (req, res, next) ->
      controller = new controller_class(req, res, next)
      if action = controller[action_name]
        action.call(controller)
      else
        next()
  
  get_controller: (controller_name) ->
    require "#{process.cwd()}/controllers/#{controller_name}"
  
  method = (method_name) ->
    (route, handler, args...) ->
      if handler? and _(handler).isString()
        @app[method_name] route, @action(handler)
      else if handler?
        # default express behavior
        # @get "/", (req, res) ->
        @app[method_name] route, handler, args...
      else
        # trick
        # @get "/": "main.index"
        for pattern, handler of route
          @app[method_name] pattern, @action(handler)
  
  get:    method("get")
  post:   method("post")
  put:    method("put")
  delete: method("delete")
  del:    method("del")
  head:   method("head")
  
  use: (args...) ->
    @app.use args...
  
  @listen: (port) ->
    app = express.createServer()
    self = new @(app)
    app.listen port or 3000

class exports.App extends BlankApp
  
  sample_secret = "adjk23sdj1201c93671jx6jk18h7ajqkh438baoqhb39h"
  
  cookie_secret: sample_secret
  session_secret: sample_secret

  environment: ->
    @use express.static(process.cwd() + '/public')
    @use express.bodyParser()
    @use express.cookieParser()
    @use express.session({ secret: @session_secret })
    @use require("connect-assets")()
    @app.register ".eco", eco
    @app.set('views', process.cwd() + '/views')
    @app.set 'view options', layout: false
    @app.set 'view engine', "eco"

class exports.Controller
  constructor: (@req, @res, @next) ->
    keygrip = new Keygrip([@cookie_secret])
    @cookies = new Cookies(@req, @res, keygrip)
    @session = @req.session
  
  send: (args...) ->
    @res.send args...
  
  render: (args...) ->
    @res.render args...

  @action: (name) ->
    (req, res, next) =>
      if @::[name]?
        controller = new @(req, res, next)
        controller[name]()
      else
        console.warn "Controller #{controller_name} has no action #{action_name}"
        next()