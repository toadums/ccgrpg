Player = require '../player'
Monster = require('../card').Monster

class Ability
  constructor: (data) ->
    @cost         = data.cost
    @validTargets = data.validTargets or {opponent: true}

  cast: (target, cb) =>
    if target instanceof Player
      toPlayer target, cb
    else if target instanceof Monster
      toMonster target, cb

module.exports = Ability