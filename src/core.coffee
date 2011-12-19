express = require("express")

class StartApp
	
	
	
	
	



class App extends StartApp

	if @dev?
		@use ...
		@set ...
	
	if @production?
		@use ...
	
	
	@set require "./config"
		
	@use express.cookieParser
		
	@set {module}
	
	@set controllers_dir: "controllers"
	
	@conf
	
	@mount "/asdasd", AnotherController # checked if StartApp exists in prototype chierarchy
	@mount "/elo", (req, res) -> # standard connect middleware
	
	@get "/", "index"
	
	index: ->
		@send "hello"


App.listen