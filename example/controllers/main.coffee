class module.exports extends require("../../lib/startapp").Controller
  
  index: ->
    @send "hello world!"
  
  template: ->
    @render "example", title: "Startapp example"