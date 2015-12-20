db = require('./db') "#{__dirname}/../db/metrics_user"

module.exports =

  ###
  get(username, cb)`
  ------------------------
  recupere les metrics d'un user

  Parameters:
  username:nom de l'utilisateur
  ###

  get: (username, callback) ->
    console.log 'enter get'
    metrics = []
    i=0
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      [_,_username,_id] = data.key.split ':'
      [_timestamp,_value] = data.value.split '.'
      if username == _username
        metrics[i] =
          username: _username,
          id: _id,
          timestamp: _id,
          value: _value
        i++
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics

  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id

  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()

  ###
  `saveData(username, id, timestamp, value, callback)`
  ------------------------
  Sauvegarde les metrics de l'user

  Parameters:
  username: nom utlisateur
  id: id de la metrique
  timestamp:
  value: vaeur de la metrcs
  ###

  saveData: (username, id, timestamp, value, callback) ->
    console.log 'savedata enter'
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{username}:#{id}", value: "#{timestamp}.#{value}"
    ws.end()

  ###
  `removeData(username, id, timestamp, value, callback)`
  ------------------------
  supprime les metrics choisi par l'user

  Parameters:
  username: nom utlisateur
  id: id de la metrique
  timestamp:
  value: vaeur de la metrics
  NB: methode qui ne fonctionne pas
  ###

  removeData: (username, id, timestamp, value, callback) ->
    console.log 'enter'
    ws = db.createWriteStream()
    operation = [
      {
        type: 'del'
        key: "#{username}:#{id}"
        value: "#{timestamp}.#{value}"
      }
    ]
    db.batch operation, (err) ->
      if err
        console.log 'remove enter error'
      else
        console.log 'remove enter ok'
