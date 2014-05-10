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
      helpers.primeSession sessionId
      response.redirect "/session/#{ sessionId }"

app.get '/session/:sessionId', (request, response) ->
  @sessionId = request.params.sessionId

  helpers.getSessionStatus @sessionId, (error, sessionStatus) =>
    if sessionStatus is 'prime'
      token = tok.generateToken session_id: @sessionId, role: 'publisher'
      helpers.activateSession @sessionId
    else
      token = tok.generateToken session_id: @sessionId, role: 'subscriber'

    response.render 'index.jade',
      token: tok.generateToken(),
      sessionId: @sessionId
      tokKey: settings.TOK_KEY



