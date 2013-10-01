class tome.GameState
  constructor: (options={}) ->
    if options.name?
      @name = options.name
    else
      throw new Error "game states require a name"

    @frame_update_stats = new tome.GameFrameStats
    @frame_render_stats = new tome.GameFrameStats
    @controllers = options.controllers ? []
    @entities = options.entities ? []

  update: (timestamp) =>
    @frame_update_stats.step timestamp
    @controllers.forEach (controller) =>
      controller.update? @entities, @frame_update_stats, this
    return

  render: (timestamp) =>
    @frame_render_stats.step timestamp
    @controllers.forEach (controller) =>
      controller.render? @entities, @frame_render_stats, this
    return
#
#  json: ->
#    controllers: @controllers.json()
#    entities: @entities.json()
#
#  jsonString: ->
#    JSON.stringify @json()
