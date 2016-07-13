'use strict'
export class Controller
  (@model, @path) ->
    @schema = @model.getSchema!
    @selector = {}

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

  callbackHandler: (req, res, next, childName, callback) ->
    @selector[req.childName] = 1 if req.childName?
    @schema.findById do
      req.params["#{@model.getName!}_id"]
      @selector
      (err, entity) ->
        return next err if err?
        req.entity= entity
        if callback?
          callback entity
        else
          res.json entity

  getById: (req, res, next) ->
    if @path?
      res.send @path
    else
      @callbackHandler ...
    # @callbackHandler req, res, next


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
