'use strict'

entityUtil = require \../entity

export class Controller
  (@model, @path) ->
    @pathTab = @path.substr 1 .split \/ if @path?
    @schema = @model.getSchema!
    # @selector = {}

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

  isManyType: (index) ~>
    return index < @pathTab.length && index + 1 < @pathTab.length && @pathTab[index + 1].indexOf \: == 0

  isOneType: (index) ~>
    return index < @pathTab.length && (!(index + 1 < @pathTab.length) || (index + 1 < @pathTab.length && @pathTab[index + 1].indexOf \: == -1))

  getById: (req, res, next) ->
    query = @schema.findById req.params["#{@model.getName!}_id"]
    query.exec (err, entity) ->
      res.send entity


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
