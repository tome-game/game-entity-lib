require_src 'utils/factories'
require_src 'core/event'
require_src 'core/event_source'

describe 'tome.EventSource', ->
  sandbox = null

  beforeEach ->
    sandbox = sinon.sandbox.create()

  afterEach ->
    sandbox.restore()

  it 'is a function', ->
    expect(tome.EventSource).to.be.a 'function'

  describe '.on( event_type, handler )', ->
    it 'adds handler for specified event_type', ->
      handler = ->
        e = new tome.EventSource().on('foo', handler)
        expect(e.handlers['foo'].first()).to.eql handler

  describe '.off( event_type )', ->
    it 'removes all bound event handlers', ->
      e = new tome.EventSource().on('foo', ->).on('foo', ->).off('foo')
      expect(e.handlers).to.be.empty

  describe '.off( event_type, handler )', ->
    it 'removes binding for specified event handlers', ->
      [hndlr1, hndlr2] = [(-> 1), (-> 5)]
      e = new tome.EventSource().on('foo', hndlr1).on('foo', hndlr2)
      expect(e.off('foo', hndlr2).handlers['foo'].last()).to.eql hndlr1

  describe '.trigger( event_type, target )', ->
    it 'triggers an attached event handler', ->
      handler = sandbox.spy()
      new tome.EventSource().on('foo', handler).trigger('foo', {})
      expect(handler).to.have.been.calledOnce

    it 'sets the event source', ->
      src = new tome.EventSource()
      e = src.trigger('foo', -> )
      expect(e.source).to.eql src

    it 'adds specified data to the event object', ->
      e = new tome.EventSource().trigger('foo', foo: 'bar')
      expect(e.data.foo).to.eql 'bar'

    it "stops calling handlers when event's propagation stopped", ->
      [hndlr1, hndlr2] = [((e) -> e.stopPropagation()), sandbox.spy()]
      new tome.EventSource().on('foo', hndlr1).on('foo', hndlr2).trigger('foo')
      expect(hndlr2).not.to.have.been.called
