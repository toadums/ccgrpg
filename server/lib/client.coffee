async = require 'async'
_ = require 'underscore'
Player = require './player'
Control = require './decks/control'

{Monster, Spell} = require './card'


class Client
  constructor: (@socket) ->

    @player = new Player()
    Rooms.Lobby.addPlayer @player


    @socket.on "UserConnected", (name) =>

      console.log "User Connected: #{name}"
      @socket.join "Lobby"

      @player.name = name
      obj = {id: @player.id, name: @player.name}
      io.sockets.in("Lobby").emit "UserConnected", obj

    @socket.on "RoomChange", (data) =>
      return if not (room = Rooms[@player.room])?
      @socket.leave @player.room
      @socket.join data.name

      @player.room = data.name

      room.removePlayer

      newRoom = Rooms[data.name]
      if not newRoom?
        console.log "Room doesn't exist!!: \n #{data.name}"
        return

      startNew = not (newRoom.player1 && newRoom.player2)

      newRoom.addPlayer @player

      @socket.broadcast.to(data.name).emit "RoomPlayerEnter", {id: @player.id, name: @player.name}
      @socket.emit "RoomChange",
        name: newRoom.name
        player1: newRoom.player1
        player2: newRoom.player2

      deck = _.map @player.deck, (card) =>
        _.extend card, {type: card.constructor.name}


      @socket.emit "DeckList", {playerId: @player.id, deck: deck}

      async.each(
        @player.deck
        (card, cb) =>
          newRoom.allCards[card.id] = card
          cb()
        (err) =>
          if err then console.log "Error in RoomChange, adding cards to allCards obj: \n #{err}"
      )

      gameData = newRoom.startNewGame(@socket)

    @socket.on "TurnEnd", () =>
      Rooms[@player.room].changeTurns()

    @socket.on "CardMoved", (data) =>
      io.sockets.in(@player.room).emit "CardMoved", data
      return unless (card = Rooms[@player.room].getCard data.cardId)?

      card.x = data.x
      card.y = data.y


    @socket.on "CardDropped", (data) =>
      return unless (card = Rooms[@player.room].getCard data.cardId)?

      if card instanceof Monster
        return if @player.strength.remaining < card.cost
        @player.strength.decrease card.cost
      else if card instanceof Spell
        return if @player.intel.remaining < card.cost
        @player.intel.decrease card.cost

      card.x = data.x
      card.y = data.y

      card = _.extend card, {type: card.constructor.name}

      io.sockets.in(@player.room).emit "CardPlayed",
        playerId: data.playerId
        card: card

    @socket.on "StatAdd", (data) =>

      room = Rooms[@player.room]

      if @player.hasUsedResource or room.activePlayer isnt @player.id
        console.log "Player tried to add a resource when they really shouldn't have..."
        return
      @player.addStat data.stat

      io.sockets.in(@player.room).emit "StatAdd", data

    @socket.on "ActiveChanged", (data) =>
      room = Rooms[@player.room]
      room.active = room.allCards[data.cardId]

      io.sockets.in(@player.room).emit "ActiveChanged", data

    @socket.on "TargetChanged", (data) =>
      room = Rooms[@player.room]
      room.target = room.allCards[data.cardId]

      io.sockets.in(@player.room).emit "TargetChanged", data

module.exports = Client


