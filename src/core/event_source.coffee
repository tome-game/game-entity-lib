class tome.EventSource

  constructor: ->
    @handlers = {}

  on: (event_type, handler) =>
    @handlers[event_type] ||= collection []
    @handlers[event_type].add handler
    return this

  off: (event_type, handler=false) =>
    if handler
      @handlers[event_type] = @handlers[event_type].without(handler)

    if !handler or @handlers[event_type]?.isEmpty()
      delete @handlers[event_type]

    return this

  trigger: (event_type, data={}) =>
    event = new tome.Event
      type: event_type, data: data, source: this

    if @handlers[event_type]
      callEventHandlers(event, @handlers[event_type])

    return event

# private

callEventHandlers = (event, handlers) ->
  for handler in handlers.array()
    return if event.stopped
    handler.call(event.source, event)

