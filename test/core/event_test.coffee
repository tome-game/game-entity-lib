require_src 'core/event'

describe 'tome.Event', ->

  it 'is a function', ->
    expect(tome.Event).to.be.a 'function'

  describe '.stopPropagation(  )', ->

    it "sets the event's `.stopped` property", ->
      e = new tome.Event().stopPropagation()
      expect(e.stopped).to.be.true
