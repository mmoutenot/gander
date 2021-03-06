settings = require './settings'

app = settings.app
express = settings.express
inst = settings.inst

app.configure ->
  app.use express.cookieParser()
  app.use express.session(
    store: new settings.redisStore(
      host: settings.REDIS_HOST
      port: settings.REDIS_PORT
      db: 2
      pass: ''
    )
    secret: process.env.SESSION_SECRET or '1asdfkljh32rsadfa34'
  )

  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use app.router
  app.use express.static(__dirname + '/public/')
  app.use express.favicon('public/static/images/favicon.ico')

  console.log 'running on ' + settings.HOSTNAME

app.configure 'development', ->
  app.use express.logger()
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure 'production', ->
  app.use express.errorHandler()

controllers = require './controllers'
