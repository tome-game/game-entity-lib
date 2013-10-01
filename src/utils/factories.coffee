do (root = global ? window) ->

  root.findClass = (name, suffix='', strict=false) ->
    unless /([A-Z0-9][a-z0-9]+)+/.test class_name
      class_name = _.str.classify "#{class_name}"
    suffixed_name = "#{class_name}#{suffix}"
    clazz = tome[class_name] ? tome[suffixed_name] ? root[class_name] ? root[suffixed_name]
    throw exception "Can't find class #{class_name}" if strict && !_.isFunction clazz
    return clazz

  root.collection = (items=[]) ->
    return items if items instanceof tome.Collection
    items = arguments unless items.constructor.name == 'Array'
    new tome.Collection items

  root.entity = (components=[]) ->
    components = arguments if arguments.length > 1
    new tome.Entity components: components

  root.component = (name, attrs={}) ->
    new (findClass(name) ? tome.EntityComponent)
      attributes: attrs

  root.controller = (name) ->
    new (findClass(name) ? tome.EntityController)
      attributes: attrs

  root.components = (components={}) ->
    collection(
      for name, attrs of components
        component(name, attrs)
    )
