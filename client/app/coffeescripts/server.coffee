class Server
  constructor: () ->
    @host = window.location.origin
    @socket = io.connect(@host)

    @socket.emit "UserConnected", Math.random()
    @socket.emit "RoomChange", {name: "r1"}

    console.log "You are connected to: #{@host}"

    @login = new Login @socket

class Login
  constructor: (@socket) ->
    @username = ko.observable ""

  onSubmit: ->
    console.log "Username changed to: #{@username()}"
    @socket.emit "UserConnected", @username()
