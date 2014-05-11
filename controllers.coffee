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
    if sessionStatus is helpers.SESSION_STATUS_PENDING
      isPublisher = true
      token = tok.generateToken session_id: @sessionId, role: settings.OpenTok.RoleConstants.PUBLISHER
      helpers.activateSession @sessionId
    else if sessionStatus is helpers.SESSION_STATUS_ACTIVE
      isPublisher = false
      token = tok.generateToken session_id: @sessionId, role: settings.OpenTok.RoleConstants.SUBSCRIBER

    response.render 'index.jade',
      token: token
      sessionId: @sessionId
      tokKey: settings.TOK_KEY
      isPublisher: isPublisher

app.post '/session/:sessionId/complete', (request, response) ->
  @sessionId = request.params.sessionId

  helpers.getSessionStatus @sessionId, (error, sessionStatus) =>
    if sessionStatus is helpers.SESSION_STATUS_ACTIVE or sessionStatus is helpers.SESSION_STATUS_PENDING

      helpers.completeSession @sessionId

      response.json
        session:
          id: @sessionId
          status: helpers.SESSION_STATUS_COMPLETE




