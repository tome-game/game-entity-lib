require_src 'components/position'

describe 'tome.PositionComponent', ->

  it 'is a function', ->
    expect(tome.PositionComponent).to.be.a 'function'

  describe '.distance( position )', ->

    it 'caclulates the distance to the passed position component', ->
      pos1 = new tome.PositionComponent
        attrs: x: 0, y: 0, z: 0
      pos2 = new tome.PositionComponent
        attrs: x: 42, y: 0, z: 34
      # expect(parseInt(pos1.distance(pos2))).to.eql(5)