{Monster, Spell} = require '../card'
Deck = require './deck'
Cards = require '../cards/cards'

class Control extends Deck
  constructor: () ->
    super
    for i in [0..19] by 1
      card = new Spell Cards.DamageTwo

      @cards.push card

module.exports = Control