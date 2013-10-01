require_src 'core/entity'

UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

describe 'tome.Entity', ->

  it 'is a function', ->
    expect(tome.Entity).to.be.a 'function'

  describe 'new tome.Entity(  )', ->

    it 'creates an entity with an id', ->
      entity = new tome.Entity
      expect(entity.id).not.to.eql null

  describe 'new tome.Entity( components: [array] )', ->

    it 'creates entity with passed components', ->
      component = {name: 'one'}
      entity = new tome.Entity components: [component]
      expect(entity.components().one).to.eql component

  describe '.add( component )', ->

    it 'adds components to new entity', ->
      entity = new_entity {name: 'one'}
      expect(entity.has 'one').to.eql true

  describe '.components( )', ->

    it "returns all entity's components", ->
      entity = new_entity {name: 'one'}, {name: 'two'}
      components =  {one: {name: 'one'}, two: {name: 'two'}}
      expect(entity.components()).to.eql components

  describe '.id', ->
    it 'looks like a uuid', ->
      expect(new tome.Entity().id).to.match UUID_REGEX

  describe '.get( component_name  )', ->
    it 'returns component for component_name', ->
      component = {name: 'two', foo: 'bar'}
      entity = new_entity {name: 'one'}, component
      expect(entity.get('two')).to.eql component

    it 'returns false when entity has named component', ->
      entity = new_entity {name: 'one'}
      expect(entity.has('two')).to.eql false

  describe '.is', ->
    it 'aliases the tome.Entity.add method', ->
      expect(tome.Entity::has).to.eql tome.Entity::is

new_entity = (components...) ->
  new tome.Entity components: components