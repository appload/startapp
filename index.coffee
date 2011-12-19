express = require "express"

class StartApp
  @_decorators or= []
  
  @listen = (options...) ->
    app = express.createServer()
    for decorator in @_decorators
      decorator.call app
    app.listen options...
  
  