require_src 'core/event'
require_src 'core/event_source'
require_src 'core/entity_component'
require_src 'components/account'

describe 'tome.AccountComponent', ->

  it 'is a function', ->
    expect(tome.AccountComponent).to.be.a 'function'
