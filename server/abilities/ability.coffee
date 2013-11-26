Player = require '../player'

class Ability
  constructor: (data) ->
    @cost         = data.cost
    @validTargets = data.validTargets or {opponent: true}

  cast: (target, cb) =>

    type = target.constructor.name.toLowerCase()

    # TODO make sure valid target!!
    if type is 'player'
      @toPlayer target, cb
    else if type is 'monster'
      @toMonster target, cb

module.exports = Ability