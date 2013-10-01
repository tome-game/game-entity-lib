require_src 'core/entity_component'

describe 'tome.EntityComponent', ->

  it 'is a function', ->
    expect(tome.EntityComponent).to.be.a 'function'

  describe '.name', ->

    it "returns a name based on the component's class name", ->
      c = new class SuperGreatComponent extends tome.EntityComponent
      expect(c.name).to.eql 'super_great'

  describe '.attributes( )', ->

    it "returns the component's attribute obj", ->
      attrs = one: 2
      expect(new tome.EntityComponent(attributes: attrs).attributes()).to.eql attrs

  describe '.make_accessible( property_names )', ->

    it "creates methods for attr names passed as array", ->
      class ExampleComponent extends tome.EntityComponent
        accessible_attrs: ['foo', 'bar']
      expect(typeof new ExampleComponent().foo).to.eql('function')

    it "creates methods for attr names passed as string", ->
      class ExampleComponent extends tome.EntityComponent
        accessible_attrs: 'foo bar'

      expect(typeof new ExampleComponent().foo).to.eql('function')

  describe 'accessible attribute', ->
    class ExampleComponent extends tome.EntityComponent
      accessible_attrs: 'foo bar'

    it "getter returns the attribute value", ->
      expect(new ExampleComponent(attributes: foo: 'bar').foo()).to.eql 'bar'

    it "setter sets the attribute value", ->
      entity = new ExampleComponent(attributes: foo: 'x')
      entity.foo('bar')
      expect(entity.foo()).to.eql 'bar'

  describe '.has( attribute )', ->

    it 'returns true if component has attribute', ->
      c = new tome.EntityComponent().set('key', 'val')
      expect(c.has('key')).to.eql true

    it 'returns false unless component has attribute', ->
      c = new tome.EntityComponent()
      expect(c.has('key')).to.eql false

  describe '.get( attribute )', ->

    it 'returns attribute value', ->
      c = new tome.EntityComponent()
      c.attrs.key = 'val'
      expect(c.get('key')).to.eql 'val'

  describe '.set( attribute, value )', ->

    it 'sets an attribute value', ->
      c = new tome.EntityComponent().set('key', 'val')
      expect(c.attrs.key).to.eql 'val'

    it 'deletes an attribute when passed undefined', ->
      c = new tome.EntityComponent( key: 42).set('key', undefined)
      expect(c.attrs).to.eql {}

    it 'deletes an attribute when passed null', ->
      c = new tome.EntityComponent( key: 42).set('key', null)
      expect(c.attrs).to.eql {}

  describe '.set( attributes )', ->
    it 'sets attributes passed as obj', ->
      attrs = key: 'val', foo: 42
      c = new tome.EntityComponent().set(attrs)
      expect(c.attrs).to.eql attrs

    it "doesn't share attributes across separate instances", ->
      entity1 = new tome.EntityComponent().set('key', 'val')
      entity2 = new tome.EntityComponent().set foo: 'bar'
      expect(entity1.attrs).not.to.eql entity2.attrs

  describe '.readOnly( )', ->

    it 'returns a copy of the object with the same attributes', ->
      c = new tome.EntityComponent().set('key', 'val').readOnly()
      expect(c.get('key')).to.eql 'val'

    it 'returns object that throws error when attempting to edit attributes', ->
      c = new tome.EntityComponent().readOnly()
      expect(-> c.set('key', true)).to.throw Error

  describe 'with json', ->
    new_entity = new tome.EntityComponent(attributes: {foo: 'bar'})
    json = {name: 'entity', attributes: foo: 'bar'}

    describe '.json( )', ->

      it 'returns the component as a json object', ->
        expect(new_entity.json()).to.eql json

    describe '.jsonString', ->

      it 'returns the component as a string of json', ->
        expect(new_entity.jsonString()).to.eql JSON.stringify(json)