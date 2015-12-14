db = require('./db') "#{__dirname}/../db/metrics"

module.exports =
  ###
  `get()`
  ------

  Returns some hard coded metrics


  get: () ->
    return [
      timestamp: new Date('2015-12-01 10:30 UTC').getTime(),
      value: 26
    ,
      timestamp: new Date('2015-12-01 10:35 UTC').getTime(),
      value: 23
    ,
      timestamp: new Date('2015-12-01 10:40 UTC').getTime(),
      value: 20
    ,
      timestamp: new Date('2015-12-01 10:45 UTC').getTime(),
      value: 19
    ,
      timestamp: new Date('2015-12-01 10:50 UTC').getTime(),
      value: 18
    ,
      timestamp: new Date('2015-12-01 10:55 UTC').getTime(),
      value: 20
    ]


    `getData(id,cb)`
    ------------------------
    get some metrics with a given id

    Parameters:
    `id`: An integer defining a batch of metrics
    ###

  get: (username, callback) ->
    console.log 'enter get'
    metrics = []
    i=0
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      [_,_username] = data.key.split ':'
      [_id,_timestamp,_value] = data.value.split ':'
      metrics[i] =
        username: _username,
        id: _id,
        timestamp: _id,
        value: _value
      i++
    console.log 'sortie get data'
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



  saveData: (username, id, timestamp, value, callback) ->
    console.log 'savedata enter'
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{username}", value: "#{id}.#{timestamp}.#{value}"
    console.log "savedata enter user:#{username}:#{id}", value: "#{timestamp}:#{value}"
    ws.end()
