#= require ../object

class Batman.Query extends Batman.Object
  constructor: (@model, options = {}) ->
    super(options)

  where: (options) ->
    @set('where', options)
    return this

  limit: (amount) ->
    @set('limit', amount)
    return this

  load: (options, callback) ->
    [options, callback] = [{}, options] if !callback

    @mixin(options)
    @model.loadWithOptions(@toJSON(), callback)

Batman.Queryable =
  initialize: ->
    for own name, func of Batman.Query.prototype
      continue if name in ['constructor']

      @[name] = ->
        query = new Batman.Query(this)
        query[name].apply(query, arguments)
        return query
