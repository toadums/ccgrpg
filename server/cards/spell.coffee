Card = require './card'

class Spell extends Card
  constructor: (data) ->
    super data
    @positive     = false



module.exports = Spell