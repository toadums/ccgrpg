{Monster, Spell} = require '../card'
Deck = require './deck'
Cards = require '../cards/cards'

class Control extends Deck
  constructor: () ->
    super
    for i in [0..19] by 1
      if i%3 is 1 then @cards.push new Spell(Cards.DamageTwo)
      else if i%3 is 2 then @cards.push new Spell(Cards.DrawOne)
      else if i%3 is 0 then @cards.push new Spell(Cards.HealThree)



module.exports = Control