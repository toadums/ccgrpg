{Monster, Spell, Cards} = require '../cards'
Deck = require './deck'

class RDW extends Deck
  constructor: () ->
    super
    for i in [0..19] by 1
      if i%4 is 1 then @cards.push new Monster(Cards.OneOne)
      else if i%4 is 2 then @cards.push new Monster(Cards.OneOne)
      else if i%4 is 3 then @cards.push new Spell(Cards.DamageTwo)
      else if i%4 is 0 then @cards.push new Monster(Cards.TwoTwo)



module.exports = RDW