Ability = require('./ability')

class Draw extends Ability
  constructor: (data) ->
    super data
    @value = data.value or 0

  toPlayer: (target, cb) =>
    for i in [1..@value] by 1
      target.draw cb

module.exports = Draw