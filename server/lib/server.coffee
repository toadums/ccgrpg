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


root.Rooms =
  r1: new Room "r1"
  r2: new Room "r2"
  r3: new Room "r3"
  r4: new Room "r4"
  r5: new Room "r5"
  r6: new Room "r6"
  r7: new Room "r7"
  r8: new Room "r8"
  r9: new Room "r9"
  r10: new Room "r10"

Rooms.Lobby = new Room 'Lobby'

io.sockets.on 'connection', (socket) =>
  client = new Client socket
