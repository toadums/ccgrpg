ko.bindingHandlers.draggable =
    init: (element, valueAccessor) ->

      options = ko.utils.unwrapObservable(valueAccessor())
      element = $(element)

      if ko.unwrap options.enabled
        $(element).draggable()
        $(element).on 'drag', options.drag

ko.bindingHandlers.droppable =
    init: (element, valueAccessor) ->

      options = ko.utils.unwrapObservable(valueAccessor())
      element = $(element)

      $(element).droppable(options)
      $(element).on 'drop', options.drop