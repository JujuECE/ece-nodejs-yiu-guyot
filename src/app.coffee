express = require 'express'
morgan  = require 'morgan'
session = require 'express-session'
levelStore = require('level-session-store')(session)
metrics_user = require './metrics_user'
bodyparser = require 'body-parser'
app = express()
user = require './user'
jade = require 'jade'
stylus = require 'stylus'
nib = require 'nib'


compile = (str, path) ->
  stylus(str).set('filename', path).use nib()

app.use require('body-parser')()
app.set 'port', 1337
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"
app.use stylus.middleware(src: __dirname + '/public')

app.use stylus.middleware(
  src: __dirname + '/public'
  compile: compile)
app.use express.static(__dirname + '/public')


app.get '/users.json', (req,res) ->
  user.get "a6", (err,data) ->
    if err then throw err
    res.status(200).send data


app.use bodyparser.json()
app.use bodyparser.urlencoded()
app.use '/', express.static "#{__dirname}/../public"
app.use session
  secret: 'anythingIsASecret'
  store: new levelStore '.db/sessions'
  resave: true
  saveUninitialized: true


app.get '/',(req,res) ->
  res.render 'index'

app.get '/login', (req, res) ->
  res.render 'login'

app.get '/signup', (req, res) ->
  res.render 'signup'


# Envoie l'utilisateur a la page user si lecompte est bon sinon renvoie a la page login
app.post '/login', (req, res) ->
  user.get req.body.username, (err, data) ->
    if err
      throw err
    unless req.body.password == data.password
      res.redirect '/login'
    else
      req.session.loggedIn = true
      req.session.username = req.body.username
      res.redirect '/user'

# Envoie l'utilisateur a la page login
app.post '/loginpage', (req,res) ->
  res.redirect '/login'

# Envoie l'utilisateur a la page signup
app.post '/signuppage', (req,res) ->
  res.redirect '/signup'

# Envoie l'user a la page principal si la création du compte s'est bien fait
app.post '/signup', (req,res) ->
  user.save req.body.username, req.body.password, req.body.email, req.body.name, (err) ->
    if err then res.status(500).json err
    else
      req.session.loggedIn = true
      req.session.username = req.body.username
      res.redirect '/'

#Sauvegarde les metrics inseré par l'user
app.post '/save_metrics', (req,res) ->
  metrics_user.saveData req.session.username, req.body.id, req.body.timestamp, req.body.value, (err) ->
    if err
       throw err
    else
       res.redirect '/user'
# supprime les metrics voulu par l'use NB: methode ne fonctionne pas
app.post '/remove_metrics', (req,res) ->
  metrics_user.removeData req.session.username, req.body.id, req.body.timestamp, req.body.value, (err) ->
    if err
      throw err
    else
       res.redirect '/user'

#Recupere toutes les metrics dans la base
app.post '/metrics', (req,res) ->
  metrics_user.get req.session.username, (err,data) ->
    res.status(200).send data

app.post '/metrics', (req,res) ->
  metrics_user.get req.session.username, (err,data) ->
    res.status(200).send data

# Se deconnecter de son compte renvoi a la page principale
app.post '/logout', (req,res) ->
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/'

#si l'utilisateur n'est pas connecté a un compte il est renvoyé a la page principale
authCheck = (req, res, next) ->
  unless req.session.loggedIn == true
    res.redirect '/'
  else
    next()

#Envoie l'user a la page user si il est bien coonecte a un compte
app.get '/user', authCheck,(req, res) ->
  res.render 'user', name: req.session.username

#Envoi l'user à la page principale
app.get '/',(req, res) ->
  res.redirect '/index'


app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
