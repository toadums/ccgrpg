class Cards
  constructor: () ->
    @cards = ko.observableArray []
    @active = ko.observable null
    @target = ko.observable null

  add: (card) =>
    @cards.push card

  remove: (cardOrId) =>
    if cardOrId instanceof Card
      card = cardOrId
    else
      card = _.find @cards(), (card) =>
        card.id() is cardOrId

    @cards _.without(@cards(), card)
    card

  find: (id) =>
    _.each @cards(), (card) =>
      card.id() is id

  clear: () =>
    @cards.splice 0