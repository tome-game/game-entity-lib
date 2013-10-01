_ = require 'lodash'
_s = require 'underscore.string'

class tome.EntityComponent extends tome.EventSource

  constructor: (options={}) ->
    @attrs = {}
    @set attr, v for attr, v of (options.attributes ? options.attrs ? {})
    @name = options.name ? getName(this)
    @make_accessible(@accessible_attrs) if @accessible_attrs?

  attributes: ->
    @attrs

  entity: (entity) ->
    if entity then @entity = entity else entity

  get: (attr_name) ->
    @attrs[attr_name]

  has: (attr_name) ->
    @get(attr_name) not in [null, undefined]

  is: EntityComponent::has

  json: ->
    name: @name
    attributes: @attrs

  jsonString: ->
    JSON.stringify @json()

  make_accessible: (attr_names) ->
    attr_names = attr_names.split?(' ') ? attr_names
    attr_names.forEach (attr_name) =>
      @constructor::[attr_name] = (value) =>
        if value
          @set attr_name, value
          return this
        else
          return @get attr_name

  readOnly: ->
    new EntityComponent(attributes: _.cloneDeep @attrs).set(readonly: true)

  set: (attr, val=null) ->
    if _.isObject attr
      setAttribute(@attrs, attr_name, val) for attr_name, val of attr
    else
      setAttribute(@attrs, attr, val)
    return this

# private

getName = (component) ->
  _s.underscored component.constructor.name.replace(/component/i, '')

setAttribute = (attrs, attr, val) ->
  if attrs.readonly == true
    throw exception "Attempting to set #{attr} for read-only component"

  val = val?() if _.isFunction val
  if val in [undefined, null] then delete attrs[attr]
  else attrs[attr] = val
