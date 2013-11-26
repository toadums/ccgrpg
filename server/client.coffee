async = require 'async'
_ = require 'underscore'
Player = require './player'
{Control} = require './decks'

{Monster, Spell} = require './cards'
Room = require './room'

class Client
  constructor: (@socket) ->
    @player = new Player()
    Rooms.Lobby.addPlayer @player

    @socket.on "disconnect", () =>
      return if @player.room is "Lobby"
      return unless (room = Rooms[@player.room])?
      # TODO: Remove specators
      delete Rooms[room.name]
      @socket.broadcast.to(@player.room).emit "PlayerLeft"
    @socket.on "PlayerLeft", () =>

      @joinRoom(Rooms.Lobby)
      @socket.emit "JoiningLobby"

      @player.clear()

    @socket.on "UserConnected", (name) =>

      console.log "User Connected: #{name}"
      @socket.join "Lobby"

      @player.name = name
      obj = {id: @player.id, name: @player.name}
      @socket.emit "UserConnected", obj

    @socket.on "RoomChange", (data) =>

      if data.name is '??'
        room = _.find Rooms, (value, key) =>
          not (value.player2? and value.player1?) and value.name isnt "Lobby"
        if not room?
          room = new Room Math.random()
          Rooms[room.name] = room
      else if not (room = Rooms[data.name])?
        room = (Rooms[data.name] = new Room data.name)

      @joinRoom room

      @socket.emit "RoomChange",
        name: room.name
        player1: room.player1
        player2: room.player2

      deck = _.map @player.deck, (card) =>
        _.extend card, {type: card.constructor.name}

      @socket.emit "DeckList", {playerId: @player.id, deck: deck}

      async.each(
        @player.deck
        (card, cb) =>
          room.allCards[card.id] = card
          cb()
        (err) =>
          if err then console.log "Error in RoomChange, adding cards to allCards obj: \n #{err}"
      )

      gameData = room.startNewGame(@socket)

    @socket.on "TurnEnd", () =>

      return if (Rooms[@player.room].checkWinner (message) => io.sockets.in(@player.room).emit "GameOver", message)

      Rooms[@player.room].cleanup (message) => io.sockets.in(@player.room).emit "CardRemove", message
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

      @player.play card.id

      room = Rooms[@player.room]
      room.activeCards[card.id] = card

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
      if data.id is null
        room.active = null
      else

        card = room.activeCards[data.id]
        if not card?
          player = if room.player1.id is data.id then room.player1 else if room.player2.id is data.id then room.player2

        room.active = card or player
      io.sockets.in(@player.room).emit "ActiveChanged", data

    @socket.on "TargetChanged", (data) =>
      room = Rooms[@player.room]
      if data.id is null
        room.active = null
      else
        card = room.activeCards[data.id]
        if not card?
          player = if room.player1.id is data.id then room.player1 else if room.player2.id is data.id then room.player2

        room.target = card or player

      io.sockets.in(@player.room).emit "TargetChanged", data

    @socket.on "SpellCast", (data) =>
      room = Rooms[@player.room]

      card = room.activeCards[data.active]
      target = if room.player1.id is data.target then room.player1 else if room.player2.id is data.target then room.player2 else room.activeCards[data.target]

      _.each card.abilities, (ab) =>
        ab.cast(target, (type, message) =>
          io.sockets.in(@player.room).emit type, message)

      room.removeCard card.id

      io.sockets.in(@player.room).emit "CardRemove", {cardId: card.id}

      io.sockets.in(@player.room).emit "ActiveChanged", {id: null}
      io.sockets.in(@player.room).emit "TargetChanged", {id: null}

    @socket.on "Attack", (data) =>
      room = Rooms[@player.room]

      attacker = room.activeCards[data.attacker]

      return if attacker.exhausted

      if (defender = room.activeCards[data.defender])?

        # TODO On attack abilities cast here?

        attacker.health -= defender.attack
        defender.health -= attacker.attack

        io.sockets.in(@player.room).emit "MonsterLife", {id: attacker.id, life: attacker.health}
        io.sockets.in(@player.room).emit "MonsterLife", {id: defender.id, life: defender.health}

      else
        if data.defender is room.player1.id
          defender = room.player1
        else if data.defender is room.player2.id
          defender = room.player2
        else return

        defender.life -= attacker.attack
        io.sockets.in(@player.room).emit "PlayerLife", {id: defender.id, life: defender.life}

      attacker.exhausted = true

      io.sockets.in(@player.room).emit "ActiveChanged", {id: null}
      io.sockets.in(@player.room).emit "TargetChanged", {id: null}

      io.sockets.in(@player.room).emit "MonsterExhaust", {cardId: attacker.id, value: attacker.exhausted}

  joinRoom: (room) =>
      @socket.leave @player.room
      @socket.join room.name

      @player.room = room.name

      room.removePlayer

      startNew = not (room.player1 && room.player2)

      room.addPlayer @player

      @socket.broadcast.to(room.name).emit "RoomPlayerEnter", {id: @player.id, name: @player.name}

module.exports = Client


