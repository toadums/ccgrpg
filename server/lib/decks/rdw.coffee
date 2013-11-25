{Monster, Spell, Cards} = require '../cards'
Deck = require './deck'

class RDW extends Deck
  constructor: () ->
    super
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)

    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)
    @cards.push new Monster(Cards.OneOne)

    @cards.push new Monster(Cards.TwoTwo)
    @cards.push new Monster(Cards.TwoTwo)
    @cards.push new Monster(Cards.TwoTwo)
    @cards.push new Monster(Cards.TwoTwo)
    @cards.push new Monster(Cards.TwoTwo)

    @cards.push new Monster(Cards.TwoTwo)
    @cards.push new Monster(Cards.TwoTwo)

    @cards.push new Spell(Cards.DamageTwo)
    @cards.push new Spell(Cards.DamageTwo)
    @cards.push new Spell(Cards.DamageTwo)
    @cards.push new Spell(Cards.DamageTwo)
    @cards.push new Spell(Cards.DamageTwo)

    @cards.push new Spell(Cards.DamageFive)
    @cards.push new Spell(Cards.DamageFive)
    @cards.push new Spell(Cards.DamageFive)

    @cards.push new Spell(Cards.HealTen)
    @cards.push new Spell(Cards.HealTen)
    @cards.push new Spell(Cards.HealTen)

    @cards.push new Spell(Cards.DrawOne)
    @cards.push new Spell(Cards.DrawOne)
    @cards.push new Spell(Cards.DrawOne)
    @cards.push new Spell(Cards.DrawOne)
    @cards.push new Spell(Cards.DrawOne)

    @cards.push new Spell(Cards.DrawThree)
    @cards.push new Spell(Cards.DrawThree)
    @cards.push new Spell(Cards.DrawThree)







module.exports = RDW