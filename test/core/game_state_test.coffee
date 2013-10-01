require_src 'core/game_state'

describe 'tome.GameState', ->
  sandbox = null

  beforeEach ->
    sandbox = sinon.sandbox.create()

  afterEach ->
    sandbox.restore()

  it 'is a function', ->
    expect(tome.GameState).to.be.a 'function'

  describe 'new tome.GameState( options )', ->

    it "sets the game state's name property", ->
      game_state = new tome.GameState name: 'foo'
      expect(game_state.name).to.eql 'foo'

  describe '.update( timestamp )', ->

    it 'increments update stats by one each time update is called', ->
      game_state = new tome.GameState name: 'foo'
      game_state.update()
      game_state.render()
      expect(game_state.frame_update_stats.frame_count).to.eql 1
      game_state.update()
      game_state.render()
      expect(game_state.frame_update_stats.frame_count).to.eql 2

    it 'calls update controllers', ->
      update_spy = sandbox.spy()
      game_state = new tome.GameState
        name: 'foo'
        controllers: [update: update_spy]
      game_state.update()
      expect(update_spy).to.have.been.calledOnce

  describe '.render( timestamp )', ->

    it 'increases render stats by one step', ->
      game_state = new tome.GameState name: 'foo'
      game_state.render()
      expect(game_state.frame_render_stats.frame_count).to.eql 1
      game_state.render()
      expect(game_state.frame_render_stats.frame_count).to.eql 2

    it 'calls render controllers', ->
      render_spy = sandbox.spy()
      game_state = new tome.GameState
        name: 'foo'
        controllers: [render: render_spy]
      game_state.render()
      expect(render_spy).to.have.been.calledOnce
