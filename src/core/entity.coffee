uuid = require 'node-uuid'

class tome.Entity extends tome.EventSource

  constructor: (options={}) ->
    @id = options.id ? uuid.v4()
    @current_components = {}
    options.components?.forEach @add

  add: (component) =>
    @current_components[component.name] = component

  components: ->
    @current_components

  get: (component_name) =>
    @current_components[component_name]

  has: (component_name) =>
    @get(component_name) not in [null, undefined]

  is: Entity::has
