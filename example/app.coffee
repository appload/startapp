class ExampleApp extends require("../lib/startapp").App

  routes: ->
    @get '/': 'main.index'
    @get '/template': 'main.template'


ExampleApp.listen 3000