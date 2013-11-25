Ability = require('./ability')

class Damage extends Ability
  constructor: (data) ->
    super data
    @value = data.value or 0

  toPlayer: (target, cb) =>
    target.life -= @value
    cb "PlayerLife", {id: target.id, life: target.life}

  toMonster: (target, cb) =>
    target.health -= @value
    cb "MonsterLife", {id: target.id, life: target.health}


module.exports = Damage