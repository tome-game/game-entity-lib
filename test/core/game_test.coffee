require_src 'core/game'

describe 'tome.Game', ->

  it 'is a function', ->
    expect(tome.Game).to.be.a 'function'

  describe 'new tome.Game( states )', ->
    states =
      foo: {bar: 'gak'}
      splat: {blob: 'bloop'}

    it 'creates a game with passed states', ->
      game = new tome.Game states
      expect(game.states.foo.name).to.eql 'foo'

    it 'sets the current state to the first defined', ->
      game = new tome.Game states
      expect(game.currentState()).not.to.eql states.foo

  describe '.start(  )', ->

    it 'starts the game updates/rendering', ->

  describe '.stop(  )', ->

    it 'stops the game from updating & rendering', ->