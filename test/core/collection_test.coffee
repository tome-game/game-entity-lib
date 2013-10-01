require_src 'core/collection'

describe 'tome.Collection', ->

  it 'is a function', ->
    expect(tome.Collection).to.be.a 'function'

  describe 'new tome.Collection( array )', ->

    it 'creates a collection with passed array', ->
      items = [1,5,6]
      expect(new tome.Collection(items).items).to.eql items

  describe '.add( item )', ->

    it 'adds items to the collection', ->
      collection = new tome.Collection().add('foo')
      expect(collection.items).to.eql ['foo']

  describe '.add( item )', ->

    it 'adds items to the collection', ->
      collection = new tome.Collection().add('foo')
      expect(collection.items).to.eql ['foo']

  describe 'aliased lodash.js methods... ', ->

    it 'allow chaining of methods for results', ->
      c = new tome.Collection [1, 2, 3]
      expect(c.without(1).first()).to.eql 2
