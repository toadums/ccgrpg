_ = require 'underscore'
async = require 'async'

{guid} = require './util'

Control = require './decks/control'
class Player
  constructor: () ->

    @id = guid()
    @name = ""
    @room = "Lobby"

    @deck = (new Control()).cards
    @hand = []
    @activeCards = []

    @strength = new Stat
    @intel = new Stat

    @hasUsedResource = false


  draw: (message) =>
    topCard = @deck.splice(0,1)[0]
    @hand[topCard.id] = topCard

    message
      playerId: @id
      cardId: topCard.id

  addStat: (stat, amount=1) =>
    if stat is "strength"
      @strength.increase amount
    else if stat is "intel"
      @intel.increase amount

    @hasUsedResource = true

class Stat
  constructor: () ->
    @total = 0
    @remaining = 0

  increase: (amount = 1) =>
    @total += amount
    @remaining += amount

  decrease: (amount = 1) =>
    @total -= amount
    @remaining -= amount

module.exports = Player