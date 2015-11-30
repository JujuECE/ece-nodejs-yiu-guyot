module.exports =
  save: (name, callback) ->
    #save the user.....
    user = 
      id: '2222'
      name: name
    callback name
    return
  get: (id, callback) ->
    #get a user ....
    user = 
      name: 'juju'
      id: id
    callback id
    return