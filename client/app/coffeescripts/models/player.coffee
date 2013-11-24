class Player
  constructor: (@delegate, data) ->
    {
      @name
      @socket
      @player
      @activePlayer
    } = @delegate

    @id = ko.observable(data.id)
    @name = ko.observable(data.name)

    @activeCards = new Cards

    @hand = new Cards
    @deck = new Cards

    @isActivePlayer = ko.computed =>
      @activePlayer()?.id() is @id()

    @resourceUsed = ko.observable false
    @showResourceAdd = ko.computed =>
      @isActivePlayer() and not @resourceUsed()

    @life = ko.observable 30

    @strength = new Stat @, 'strength'
    @intel = new Stat @, 'intel'

    @stats = [@strength, @intel]

    @canDrag = ko.computed =>
      @player() is @


  addStat: (stat, amount=1) =>
    if stat is "strength"
      @strength.increase amount
    else if stat is "intel"
      @intel.increase amount

    @resourceUsed true

  newDeck: (data) =>
    @deck.clear()
    _.each data, (value, key) =>
      if value.type?
        card = new window[value.type] value
      else card = new Card value
      @deck.add card

  draw: (id) =>
    return unless (card = @deck.remove(id))?
    @hand.add card

    card

  startTurn: () =>
    _.each @activeCards.cards(), (card) =>
      if card instanceof Monster
        card.exhausted false

      @resourceUsed false

      # TODO: Can move your cards on BF. Turn off opps ability to move theirs

  play: (id, x, y) =>
    return unless (card = @hand.remove(id))?
    @activeCards.add card

    card.x x
    card.y y

  opponentPlay: (card) =>
    return unless (@hand.remove(card.id))?
    if card.type?
      newCard = new window[card.type] card
    else newCard = new Card card
    @activeCards.add newCard

    $cardvm = $("#card_#{newCard.id()}")
    $cardvm.css "left", card.x + 'px'
    $cardvm.css "top", card.y + 'px'

  handDrag: (data, ui) =>
    card = ko.dataFor(data.target)
    card.x ui.position.left
    card.y ui.position.top
    @socket.emit "CardMoved", {cardId: card.id(), x: ui.position.left, y: ui.position.top}

class Stat
  constructor: (@delegate, name) ->
    {
      @socket
      @id
      @showResourceAdd
    } = @delegate
    @name = ko.observable name
    @total = ko.observable 0
    @remaining = ko.observable 0

  increase: (amount = 1) =>
    @total @total()+amount
    @remaining @remaining()+amount

  decrease: (amount = 1) =>
    @remaining @remaining()-amount

  add: () =>
    return unless @showResourceAdd()
    @socket.emit "StatAdd",
      playerId: @id()
      stat: @name()

