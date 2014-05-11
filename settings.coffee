express = require 'express'
url = require 'url'
exports.express = express

#################
# database setup
#################
# Mongo
mongoHostname = process.env.MONGO_URL || 'mongodb://localhost/test'
mongoose = require 'mongoose'
console.log "Connecting to MongoDB: #{mongoHostname}"

mongoose.connect mongoHostname
exports.mongoose = mongoose

db = mongoose.connection
db.on "error", console.error.bind(console, "connection error:")
db.once "open", callback = ->
  console.log 'connected to mongodb'

# Redis
exports.REDIS_URL = url.parse process.env.REDIS_URL || 'redis://127.0.0.1:6379'
exports.REDIS_HOST = exports.REDIS_URL.hostname
exports.REDIS_PORT = exports.REDIS_URL.port

RedisStore = require('connect-redis')(express)
exports.redisStore = RedisStore

#################
# webserver setup
#################
appPort = process.env.PORT or 3000
http = require 'http'

app = express()
app.set 'view engine', 'jade'
server = http.createServer(app).listen appPort

exports.app         = app
exports.server      = server
exports.appPort     = appPort
exports.httpClient  = require 'http'
exports.HOSTNAME    = process.env.G_HOSTNAME
exports.debug       = true

#################
# socket setup
#################
io = require 'socket.io'
io = io.listen server

exports.io = io

#################
# tok setup
#################
exports.TOK_KEY    = process.env.TOK_KEY or 'KEY'
exports.TOK_SECRET = process.env.TOK_SECRET or 'SECRET'

OpenTok = require 'opentok'
exports.OpenTok = OpenTok
exports.tok = new OpenTok.OpenTokSDK exports.TOK_KEY, exports.TOK_SECRET

