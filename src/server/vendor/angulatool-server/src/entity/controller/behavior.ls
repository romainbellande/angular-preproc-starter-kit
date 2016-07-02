'use strict'

export class Behavior
  (model, behavior) ->
    @model = model
    @behavior = behavior
    @schema = @model.getSchema!
  get: (req, res, next) ~>
    @behavior.1 ...
  getName: ~> @behavior.0
  getSchema: ~> @schema
  getParams: (req, res, next, params, callback) ~>
    @schema.findById do
      req.params["#{@model.getName!}_id"]
      params
      (err, entity) ->
        res.send err if err?
        callback entity
  sendParams: (req, res, next, params) ~>
    @getParams req, res, next, params,
      (item) ->
        res.send (item)
