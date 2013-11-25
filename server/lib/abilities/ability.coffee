Player = require '../player'
{Monster, Spell} = require '../cards'

class Ability
  constructor: (data) ->
    @cost         = data.cost
    @validTargets = data.validTargets or {opponent: true}

  cast: (target, cb) =>

    # TODO make sure valid target!!
    console.log Monster, Player
    if target instanceof Player.constructor
      @toPlayer target, cb
    else if target instanceof Monster.constructor
      console.log "THISGUY"
      @toMonster target, cb

module.exports = Ability