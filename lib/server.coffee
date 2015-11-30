http = require('http')
users = require('./users.coffee')
http.createServer((req, res) ->
  path = req.url.split('/').splice(1, 2)
  if path[0] == 'get'
    users.get 11, (user) ->
      response = 
        info: 'here\'s your user !'
        user: user
      res.writeHead 200, content: 'application/json'
      res.end JSON.stringify(response)
      return
  else if path[0] == 'save'
    users.save path[1], (user) ->
      response = 
        info: 'user saved !'
        user: user
      res.writeHead 200, content: 'application/json'
      res.end JSON.stringify(response)
      return
  else
    res.writeHead 404, content: 'text/plain'
    res.end 'Not a good path'
  return
).listen 1337, '127.0.0.1'