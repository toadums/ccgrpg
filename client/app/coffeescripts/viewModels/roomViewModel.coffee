class RoomViewModel
  constructor: (@delegate, name) ->
    {
      @server
      @loggedIn
    } = @delegate

    @socket = @server.socket
    @name = ko.observable name

    @newName = ko.observable @name()

    @player1 = ko.observable null
    @player2 = ko.observable null

    @active = ko.observable null
    @target = ko.observable null

    @player = ko.observable null
    @opponent = ko.computed =>
      return null if not (@player1()? and @player2()?)
      if @player() is @player1() then @player2()
      else @player1()

    @spectators = ko.observableArray []

    @allPlayers = ko.computed =>
      players = []

      players.push @player1()
      players.push @player2()

      _.each @spectators(), (spec) =>
        players.push spec

      players

    @activePlayer = ko.computed do =>
      player = ko.observable()
      {
        read: => player()
        write: (playerOrId) =>
          player (if ko.unwrap(playerOrId) instanceof Player
            playerOrId()
          else
            if @player1()? and @player2()?
              if @player1().id() is playerOrId
                @player1()
              else
                @player2()
            else null)
      }

    @activeCards = ko.computed =>
      cards = []
      _.each @player1()?.activeCards.cards(), (card)=>
        cards.push card

      _.each @player2()?.activeCards.cards(), (card)=>
        cards.push card

      cards

    @socket.on "UserConnected", (data) =>
      player = @addOrCreatePlayer data
      @player(player)
      @loggedIn true
      console.log player.name()

    @socket.on "StatAdd", (data) =>
      return unless (player = @findPlayer data.playerId)
      console.log data
      player().addStat data.stat

    @socket.on "DeckList", (data) =>
      return unless (player = @findPlayer(data.playerId))
      player().newDeck data.deck

    @socket.on "CardDraw", (data) =>
      return unless (player = @findPlayer(data.playerId))
      card = player().draw(data.cardId)
      console.log "!x!"
      if player() is @player1()
        card.x 500
      else
        card.x 100

      card.y 20

    @socket.on "PlayerLife", (data) =>
      return unless (player = @findPlayer(data.id))?
      player().life data.life

    @socket.on "MonsterLife", (data) =>
      return unless (card = @findCard(data.cardId))?
      return unless card instanceof Monster

      card.health data.life

    @socket.on "MonsterExhaust", (data) =>
      return unless (card = @findCard(data.cardId))?
      return unless card instanceof Monster

      card.exhausted(data.value or true)

    @socket.on "CardMoved", (data) =>
      return unless (card = @findCard data.cardId)
      card.x data.x
      card.y data.y

    @socket.on "RoomPlayerEnter", (data) =>
      return if data.id is @player()?.id()
      @addOrCreatePlayer data

    @socket.on "RoomChange", (data) =>

      # TODO: Clear hands, decks, etc...Basically reset the player cept the name

      @player1 null
      @player2 null

      @name data.name

      @addOrCreatePlayer data.player1
      @addOrCreatePlayer data.player2

      @activePlayer null
      @spectators.splice 0

    @socket.on "GameStart", (data) =>
      @activePlayer data.activePlayer

      if @player().id() is data.player1.id
        @player2().newDeck data.player2.deck
      else if @player().id() is data.player2.id
        @player1().newDeck data.player1.deck
      else
        @player1().newDeck data.player1.deck
        @player2().newDeck data.player2.deck

    @socket.on "CardPlayed", (data) =>
      return unless (player = @findPlayer(data.playerId))?
      if player() is @player()
        player().play data.card.id, data.card.x, data.card.y
      else
        @opponent().opponentPlay data.card

      return unless (card = @findCard(data.card.id))?
      if card instanceof Monster
        player().strength.decrease card.cost()
      else if card instanceof Spell
        player().intel.decrease card.cost()

    @socket.on "TurnStart", (data) =>
      @active null
      @target null
      @activePlayer data.activePlayer
      @activePlayer().startTurn()

    @socket.on "ActiveChanged", (data) =>
      if not data.id? then @active null
      if (card = @findCard(data.id))?
        @active card
        @target null
      else
        return unless (player = @findPlayer(data.id))?
        @active player
        @target null

    @socket.on "TargetChanged", (data) =>
      if not data.id? then @target null
      if (card = @findCard(data.id))?
        @target card
      else
        return unless (player = @findPlayer(data.id))?
        @target player()

    @socket.on "CardRemove", (data) =>
      @removeCard data.cardId

    @socket.on "JoiningLobby", () =>
      @player().clear()
      @player1 null
      @player2 null

      @name "Lobby"


    @socket.on "PlayerLeft", () =>
      @socket.emit "PlayerLeft"

  addOrCreatePlayer: (data) =>
    return unless data?
    player = @findPlayer(data.id)?()

    if not player?
      player = new Player @, data

    # We dont want to add a player multiple times (can add spectators as players, sure why not)
    return if @player1() is player or @player2() is player

    if @name is "Lobby" or (@player1()? and @player2()?)
      @spectators.push player
    else if not @player1()?
      @player1 player
    else if not @player2()?
      @player2 player

    player

  findPlayer: (id) =>
    return @player if @player()?.id() is id
    return @player1 if @player1()?.id() is id
    return @player2 if @player2()?.id() is id

    _.find @spectators(), (spec) =>
      spec.id is id

  findCard: (id) =>
    card = _.find @activeCards(), (card) => card.id() is id
    return card if card?
    card = _.find @player1()?.hand.cards(), (card)=> card.id() is id
    return card if card?
    card = _.find @player2()?.hand.cards(), (card)=> card.id() is id
    return card if card?

  handleDrop: (data, ui) =>
    $board = $("#board")
    $card = $(ui.helper)

    card = ko.dataFor $card.get(0)

    x = $card.offset().left - $board.offset().left
    y = $card.offset().top - $board.offset().top

    @socket.emit "CardDropped", {playerId: @player().id(), cardId: card.id(), x: x, y: y}

  onSubmit: () =>
    @socket.emit "RoomChange", {name: @newName()}
    false

  endTurn: () =>
    @socket.emit "TurnEnd"

  cardClick: (data, ui) =>
    return unless @player()?.isActivePlayer()

    if @active() is data and @target()?
      if @active() instanceof Spell then @castSpell()
      if @active() instanceof Monster then @attack()
      return

    if _.contains @player().activeCards.cards(), data
      if not @active()?
        @active data
        @socket.emit "ActiveChanged", {id: data.id()}
        return
      else if @active() is data
        @active null
        @target null
        @socket.emit "ActiveChanged", {id: null}
        return

    if @active()?
      if @target() is data
        @target null
        @socket.emit "TargetChanged", {id: null}
      else if @active()?
        @target data
        @socket.emit "TargetChanged", {id: data.id()}

  playerClick: (data, ui) =>
    return unless @player()?.isActivePlayer()
    if @active()?
      if @target() is data
        @target null
        @socket.emit "TargetChanged", {id: null}
      else
        @target data
        @socket.emit "TargetChanged", {id: data.id()}

  castSpell: () =>
    @socket.emit "SpellCast",
      active: @active().id()
      target: @target().id()

  attack: () =>
    @socket.emit "Attack",
      attacker: @active().id()
      defender: @target().id()

  removeCard: (id) =>
    @player1().activeCards.remove(id)
    @player2().activeCards.remove(id)





