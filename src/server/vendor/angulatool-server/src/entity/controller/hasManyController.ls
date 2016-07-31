'use strict'
entityUtil = require \../entity
Controller = (require \./controller).Controller
export class HasManyController extends Controller
  (@model, @parentModel, @name, @options) ->
    console.log \name, @name
    @selector = {}
    @selector[@name.plural] = 1
    super ...

  get: (req, res, next) ->
    @parentModel.schema.findById do
      req.params["#{@parentModel.name.singular}_id"]
      @selector
    .populate @name.plural
    .exec (err, entities) ~>
      return next err if err?
      res.json entities

  post: (req, res, next) ->
    data = new @schema
    for key, value of req.body
      data[key] = value
    data.save (err, entity) ~>
      return next err if err?
      query = @parentModel.schema.findById req.params["#{@parentModel.name.singular}_id"]
      query.exec (err, parent) ~>
        return next err if err?
        parent[@name.plural].push entity.id
        parent.save!
        res.json parent
