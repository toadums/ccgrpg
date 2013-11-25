Card = require './card'

class Monster extends Card
  constructor: (data) ->
    super data

    @attack       = data.attack or 0
    @health       = data.health or 0

module.exports = Monster