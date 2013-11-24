_ = require 'underscore'

Cards = require './cards/cards'

Damage = require './abilities/damage'
Draw = require './abilities/draw'
Heal = require './abilities/heal'

util = require './util'

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


  getAbility: (data) =>
    if data.name is 'damage' then new Damage data
    else if data.name is 'draw' then new Draw data
    else if data.name is 'heal' then new Heal data

class Monster extends Card
  constructor: (Data) ->
    super data

    @attack       = data.attack or 0
    @health       = data.health or 0

    @exhausted    = false

class Spell extends Card
  constructor: (data) ->
    super data
    @positive     = false

module.exports =
  Monster: Monster
  Spell: Spell
