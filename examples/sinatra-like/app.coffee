Startapp = require "../../lib/startapp"

class App extends Startapp
  
  @get "/", ->
    @send "Hello, world!"
  
  @get "/hello/:name", "hello"
  
  hello: ->
    @send "Hello, #{@params.name}!"

App.listen()