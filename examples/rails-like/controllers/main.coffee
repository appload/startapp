Startapp = require "../../../lib/startapp"

module.exports =
  
  class Main extends Startapp

    index: ->
      @send "Hello, world!"
      