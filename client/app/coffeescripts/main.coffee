
class GameViewModel
  constructor: () ->

    @server = new Server

    @loggedIn = ko.observable false

    @room = ko.observable(new RoomViewModel @, "Lobby")

    @showGuide = ko.observable false

  showHideGuide: () =>
    @showGuide !@showGuide()

game = new GameViewModel

$ ->

  ko.applyBindings game, $('html').get(0)