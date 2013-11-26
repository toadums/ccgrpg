_ = require 'underscore'

Cards = require './cards'

{Draw, Damage, Heal} = require '../abilities'

util = require '../util'

class Card
  constructor: (data) ->

    @id           = data.id or util.guid()
    @name         = data.name or ""
    @cost         = data.cost or 100
    @abilities    =
      _.map data.abilities, (ab) =>
        @getAbility ab

    @x            = data.x or 200
    @y            = data.y or 200
    @imgSrc       = data.imgSrc or ""

    @discard      = false

    @exhausted    = false

  getAbility: (data) =>
    if data.name is 'damage' then new Damage data
    else if data.name is 'draw' then new Draw data
    else if data.name is 'heal' then new Heal data

module.exports = Card