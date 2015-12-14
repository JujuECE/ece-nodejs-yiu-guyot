express = require 'express'
morgan  = require 'morgan'
session = require 'express-session'
levelStore = require('level-session-store')(session)
metrics = require './metrics'
bodyparser = require 'body-parser'
app = express()
user = require './user'
jade = require 'jade'



app.set 'port', 1337
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"

app.use require('body-parser')()


app.get '/', (req, res) ->
  res.render 'index',
    locals:
      title: 'My ECE test page'

app.get '/metrics.json', (req, res) ->
  res.status(200).json metrics.get()

app.get '/hello/:name', (req, res) ->
  res.status(200).send req.params.name

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.use bodyparser.json()
app.use bodyparser.urlencoded()
app.use '/', express.static "#{__dirname}/../public"
app.use session
  secret: 'anythingIsASecret'
  store: new levelStore '.db/sessions'
  resave: true
  saveUninitialized: true


app.get '/login', (req, res) ->
  res.render 'login'

app.get '/signup', (req, res) ->
  res.render 'signup'


app.post '/login', (req, res) ->
  user.get req.body.username, (err, data) ->
    if err
      throw err
    if req.body.password != "#{data.username}"
      res.redirect '/login'
    else
      req.session.loggedIn = true
      req.session.username = req.body.username
      res.redirect '/user'


app.post '/signuppage', (req,res) ->
  res.redirect '/signup'

app.post '/signup', (req,res) ->
  user.save req.body.username, req.body.password, req.body.email, req.body.name, (err) ->
    if err then res.status(500).json err
    else
      console.log "save user #{req.body.username} password  #{req.body.password} name #{req.body.name} "
      req.session.loggedIn = true
      req.session.username = req.body.username
      res.redirect '/'

app.post '/save_metrics', (req,res) ->
  metrics.saveData req.session.username, req.body.id, req.body.timestamp, req.body.value, (err) ->
    if err
       console.log 'saved error'
    else
       console.log 'saved ok'
       res.redirect '/'



app.get '/metrics', (req,res) ->
  metrics.get req.session.username, (err,data) ->
    res.status(200).send data



app.post '/logout', (req,res) ->
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/'

authCheck = (req, res, next) ->
  unless req.session.loggedIn == true
    res.redirect '/'
  else
    next()

app.get '/user', authCheck,(req, res) ->
  res.render 'user', name: req.session.username



app.get '/',(req, res) ->
  res.redirect '/index'



app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
