class Card
  constructor: (data) ->

    @cost = ko.observable(data.cost or -1)
    @id = ko.observable(data.id)
    @imgSrc = ko.observable(data.imgSrc or "")
    @name = ko.observable(data.name or "opponent")

    @exhausted = ko.observable false

    @isMonster = ko.observable false
    @isSpell = ko.observable false

    @x = ko.observable(data.x or 200)
    @y = ko.observable(data.y or 200)

    @x.subscribe (val) =>
      $cardvm = $("#card_#{@id()}")
      $cardvm.css "left", val + 'px'

    @y.subscribe (val) =>
      $cardvm = $("#card_#{@id()}")
      $cardvm.css "top", val + 'px'

class Monster extends Card
  constructor: (data) ->
    super data

    @attack = ko.observable(data.attack or 0)
    @health = ko.observable(data.health or 0)

    @isMonster true

class Spell extends Card
  constructor: (data) ->
    super data

    @positive = false

    @isSpell true