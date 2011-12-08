Startapp = require "../../../lib/startapp"

db =
  "f0894047-5c86-d52c-59a7-5cbbb52a8b8f":
    id: "f0894047-5c86-d52c-59a7-5cbbb52a8b8f"
    firstname: "Rafał"
  "29528e5d-dcb3-fa12-f4fa-553a419aa4d6":
    id: "29528e5d-dcb3-fa12-f4fa-553a419aa4d6"
    firstname: "Maciek"

module.exports =
  
  class Users extends Startapp
    
    # HELPERS
    
    S4: ->
      (((1+Math.random())*0x10000)|0).toString(16).substring(1)
    
    generate_guid: ->
      S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()
    
    generate_new_guid: ->
      new_guid = generate_guid()
      if db[new_guid]? then @generate_new_guid() else new_guid
    
    not_found: ->
      @send null, 404
    
    firstname_required: ->
      @send {error: "firstname is required"}, 400
    
    # ACTIONS
    
    index: ->
      @send (user for id, user of db)
    
    get: ->
      {id} = @params
      if user = db[id]
        @send user
      else
        @not_found()  
    
    create: ->
      {firstname} = @body
      if firstname?  
        id = @generate_new_guid()
        user = {id, firstname}
        db[id] = user
        @send user
      else
        @firstname_required()
    
    update: ->
      {id} = @params
      {firstname} = @body
      if firstname? and user = db[id]
        user.firstname = firstname
        @send user
      else if firstname?
        @not_found()
      else
        @firstname_required()
    
    delete: ->
      {id} = @params
      if user = db[id]
        delete db[id]
        @send user
      else
        @not_found()
    