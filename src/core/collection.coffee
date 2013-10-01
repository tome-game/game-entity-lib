_ = require 'lodash'
_s = require 'underscore.string'

class tome.Collection

  constructor: (items=[]) ->
    @items = []
    @add item for item in items when item

  add: (items...) ->
    @items.push item for item in items when item
    @length = @items.length
    return this

  array: ->
    item for item in @items

  @LODASH_METHODS = _s.words "all any at each first last rest compact
                           map reduce reduceRight find isEmpty pluck
                           filter select reject size sample difference
                           uniq intersection where without remove"

  Collection.LODASH_METHODS.forEach (method) =>
    @::[method] = (args...) ->
      args.unshift @items
      results = _[method].apply(_, args)
      if _.isArray results then new Collection(results) else results

