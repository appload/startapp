Startapp - Web App Ultra-Framework
===

## Intro

### Technology
Startapp uses bleeding-edge [Node.js](http://nodejs.org) as efficient **asynchronous** language platform and [CoffeeScript](http://coffeescript.org) transpiler to do **object oriented** magic.
### Reliability
It provides simple but robust layer on top of [Express](http://expressjs.com) - **rock-solid** microframework. 
### Scalability
It allows You to **scale** apps from one file in [Sinatra](http://sinatrarb.com) fashion to [Rails](http://rubyonrails.org)-like structure.
### Reusability
By object oriented nature it is much simpler to reuse code. In addition to **shared methods**, **inheritance**, **mixins** or **partials mounting**, Startapp allows to create your own preconfigured **app-starters** with your libraries and conventions.
### Simplicity
Of course it has **perfect defaults** if You want to start quickly and smoothly.

## Get involved

    Startapp = require "startapp"
    
    
    class App extends Startapp
      
      hello: (name = "world") ->
        @send "hello, #{name}!"
      
      @get "/", "hello"
      
      @get "/hello", "hello"
      
      @get "/hello/:name", ->
        @hello @params.name
      
      
    App.listen 3000

Fire <code>hello</code> method:

    @get "/", "hello"

Fire inline function in <code>App</code> instance context:

    @get "/hello/:name", ->
      @hello @params.name


## Installation

    npm install startapp

## Routing

Startapp provides class methods <code>@get, @post, @put, @delete</code> for corresponding HTTP methods, <code>@all</code> for all of them, <code>@mount</code> for mounting another controller at chosen endpoint and <code>@resource</code> which creates REST API defaults.

### @get, @post, @put, @delete, @all

In App class body:

      @get "/", -> @send "main page"

works the same as:

      @get "/", "index"
      
      index: -> @send "main page"

but to named functions you can refer from multiple routes or other methods like on the first example. You can also refer from other controllers:
    
    class Intro extends Startapp
      features: -> # ...
    
    class Users extends Startapp
      login: -> # ...
      signup: -> # ...
      
    class App extends Startapp
      @get  "/",                  "index"
      @get  "/features",  Intro,  "features"
      @get  "/login",     Users,  "login"
      @post "/signup",    Users,  "signup"
       
      index: -> # ...
    
    App.listen 80
    
