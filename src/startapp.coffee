express = require "express"
Cookies = require "cookies"
Keygrip = require "keygrip"
eco = require "eco"

StartappCore = require "./core"

class Startapp extends StartappCore
  
  dirname: ->
    process.cwd()
  
  constructor: ->
    super
    keygrip = new Keygrip([@cookie_secret] if @cookie_secret?)
    @cookies = new Cookies(@req, @res, keygrip)
    @session = @req.session
    @params = @req.params
    @body = @req.body
  
  send: (args...) ->
    @res.send args...
  
  get_dirname = ->
    @dirname?() or @dirname
  
  @environment: (app) ->
    app.use express.static(get_dirname() + '/public')
    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.session({ secret: "startapp" })
    app.use require("connect-assets")()
    app.set 'views', get_dirname() + '/views'
    app.set 'view options', layout: false

    app.register ".eco", eco
    app.set 'view engine', "eco"
  
  @resource: (path = "", controller = @) ->
    @get  "#{path}",      controller,  "index"
    @post "#{path}",      controller,  "create"
    @get  "#{path}/:id",  controller,  "show"
    @put  "#{path}/:id",  controller,  "update"
    @del  "#{path}/:id",  controller,  "destroy"
  
module.exports = Startapp
