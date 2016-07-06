'use strict'
export class Controller
  (@model) ->
    @schema = @model.getSchema!

  get: (req, res, next) ->
    @schema.find (err, data) ->
      next err if err?
      res.json data

  post: (req, res, next) ->
    data = new @schema
    for key, value  of req.body
      data[key] = value
    data.save (err) ->
      next err if err?
      res.sendStatus 200

  getById: (req, res, next) ->
    @schema.findById do
      req.params["#{@model.getName!}_id"]
      * password: 0
        __v: 0
      (err, entity) ->
        res.send err if err?
        res.json entity

  put: (req, res, next) ->
    @schema.findOneAndUpdate do
      _id: req.params["#{@model.getName!}_id"]
      {$set: req.body}
      {new: true}
      (err, entity) !->
        next err if err?
        res.send entity

  delete: (req, res, next) ->
    @schema.remove do
      * _id: req.params["#{@model.getName!}_id"]
      (err, user) ->
        next err if err?
        res.sendStatus 200
