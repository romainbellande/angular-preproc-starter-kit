'use strict'

export class Behavior
  (model, behavior) ->
    @model = model
    @behavior = behavior
    @schema = @model.getSchema!
  get: (req, res, next) ~>
    console.log @behavior.1
    @behavior.1 ...
  getName: ~> @behavior.0
  getSchema: ~> @schema
  getParams: (req, res, next, params) ~>
    @schema.findById do
      req.params["#{@model.getName!}_id"]
      params
      (err, entity) ->
        res.send err if err?
        res.send entity
