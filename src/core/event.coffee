class tome.Event

  constructor: (options={}) ->
    @type = options.type ? 'UNKNOWN'
    @data = options.data ? {}
    @source = options.source ? {}
    @stopped = false

  stopPropagation: ->
    @stopped = true
    return this
