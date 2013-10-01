_ = require 'lodash'
_s = require 'underscore.string'

class tome.Game
  states: {}
  current_state: null
  stopped: true

  constructor: (states={}) ->
    for name, options of states
      addState this, name, options
      unless @current_state
        setCurrentState(this, name)

  currentState: ->
    @current_state

  start: ->
    throw Error "No game states defined" if _.isEmpty @states
    @stopped = false
    @update()
    @render()
    return this

  stop: ->
    @stopped = true
    return this

  render: (timestamp) =>
    if requestAnimationFrame? and not @stopped
      @current_state.render(timestamp)
      requestAnimationFrame @render
    return

  update: =>
    unless @stopped
      @current_state.update()
      schedule tome.GameFrameStats.DEFAULT_STEP_DELTA, @update
    return

  # private

  addState = (game, state_name, state_options={}) ->
    state_options.name = state_name
    game.states[state_name] = new tome.GameState state_options

  setCurrentState = (game, name) ->
    game.current_state = game.states[name]
    return this
