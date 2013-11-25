http = require 'http'
express = require 'express'
_ = require 'underscore'

Room = require './room'
Client = require './client'

app = express()
app.use(express.static("client/public"))

server = http.createServer(app)
root.io = require('socket.io').listen(server)

port = 8142
server.listen(port)

io.set('log level', 0)
console.log "Listening on port #{port}"


root.Rooms = {}

Rooms.Lobby = new Room 'Lobby'

io.sockets.on 'connection', (socket) =>
  client = new Client socket
