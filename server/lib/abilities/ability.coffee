Player = require '../player'
Monster = require('../card').Monster

class Ability
  constructor: (data) ->
    @cost         = data.cost
    @validTargets = data.validTargets or {opponent: true}

  cast: (target, cb) =>

    # TODO make sure valid target!!

    if target instanceof Player.constructor
      @toPlayer target, cb
    else if target instanceof Monster
      @toMonster target, cb

module.exports = Ability