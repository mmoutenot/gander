url     = require 'url'
redis   = require 'redis'
settings = require './settings'
helpers = require './helpers'
subscriptions = require './subscriptions'

app = settings.app
tok = settings.tok
app.get '/share', (request, response) ->
  helpers.debug 'GET ' + request.url

  tok.createSession settings.G_HOSTNAME, {}, (err, sessionId) ->
    if err
      return throw new Error "session creation failed"
    else
      response.redirect "/session/#{ sessionId }"

app.get '/session/:sessionId', (request, response) ->
  token = tok.generateToken()
  response.render 'index.jade',
    token: tok.generateToken(),
    sessionId: request.params.sessionId
    tokKey: settings.TOK_KEY



