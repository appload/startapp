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

## Installation

    npm install startapp

## Routing

Startapp provides class methods <code>@get, @post, @put, @delete</code> for corresponding HTTP methods, <code>@all</code> for all of them, <code>@resource</code> which creates REST API defaults and <code>@mount</code> for mounting another controller at url root (<code>/</code>) or chosen url prefix (for example <code>/auth</code> or <code>/books</code>).

### @get, @post, @put, @delete, @all

In App class body:

      @get "/", -> @send "main page"

works the same as:

      @get "/", "index"
      
      index: -> @send "main page"

but to named functions you can refer from multiple routes or other methods:
  
      hello: (name = "world") ->
        @send "hello, #{name}!"
  
      @get "/", "hello"
  
      @get "/hello", "hello"
  
      @get "/hello/:name", ->
        @hello @params.name

You can also refer from other controllers:
    
    class Intro extends Startapp
      features: ->  # ...
    
    class Users extends Startapp
      login: ->     # ...
      signup: ->    # ...
      
    class App extends Startapp
      @get  "/",                  "index"
      @get  "/features",  Intro,  "features"
      @get  "/login",     Users,  "login"
      @post "/signup",    Users,  "signup"
       
      index: ->     # ...
    
    App.listen 80
    
### @resource

If you provide REST API you may want to do something like:

    class Books extends Startapp
      @get    "/books",     "index"
      @post   "/books",     "create"
      @get    "/books/:id", "show"
      @put    "/books/:id", "update"
      @delete "/books/:id", "destroy"
      
      index: ->     # ...
      create: ->    # ...
      show: ->      # ...
      update: ->    # ...
      destroy: ->   # ...

Convention comes from Rails and similarly You can use <code>@resource</code> helper instead:
    
    class Books extends Startapp
      @resource "/books"
      
      index: ->     # ...
      create: ->    # ...
      show: ->      # ...
      update: ->    # ...
      destroy: ->   # ...

You can also refer to another controller:

    class Books extends Startapp
      index: ->     # ...
      show: ->      # ...
    
    class App extends Startapp
      @resource "/books", Books

As You see, You are not obligated to implement all resource methods. Not implemented would natuarally return 404. If You want to mount your resource at the root url:

    @resource()

works the same as:

    @resource "/"    

### @mount

If You want to reuse part of Your app in another project or You simply don't want to keep all routes in one place You can use routing delegation by <code>@mount</code> class method:

    class App extends Startapp
      @mount                Auth
      @mount "/shop/books", Books

to existing controllers:

    class Auth extends Startapp
      
      @get  "/login",   "login_form"
      @post "/login",   "login"
      @get  "/logout",  "logout"
      
      login_form: ->          # GET   "/login"
      login: ->               # POST  "/login"
      logout: ->              # GET   "/logout"
    
    class Books extends Startapp
      @resource()
      @get "/:id/comments"
      
      index: ->               # GET   "/shop/books"
      show: ->                # GET   "/shop/books/:id"
      comments: ->            # GET   "/shop/books/:id/comments"
      
    
      