'use strict'

entityUtil = require \../entity

export class Controller
  (@model, @path) ->
    @pathTab = @path.substr 1 .split \/ if @path?
    # @schema = @model.getSchema!
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

  createPopulationTree: (populationTree, index, isTreeRoot) ~>
    if @isOneType index
      if isTreeRoot? && isTreeRoot
        populationTree.populate = entityUtil.get @pathTab[index] .name



  callbackHandler: (req, res, next, index, childId) ~>
    model = entityUtil.get(@pathTab[index]).model
    id = void
    if childId?
      id = childId
    else
      id = req.params["#{model.getName!}_id"]
    selector = {}
    selector[@pathTab[index+2]] = 1 if @isOneType index + 2
    model.schema.findById do
      id
      selector
      (err, entity) ~>
        return next err if err?
        req.entity= entity
        if index + 1 < @pathTab.length
          @callbackHandler req, res, next, index + 1, entity[@pathTab[index+1]]
        else
          res.json entity

  # oneTypeHandler: (req, res, next, index) ->
  #   model = entityUtil.get(@pathTab[index]).model
  #   @callbackHandler req, res, next, model

  # manyTypeHandler: (req, res, next, index) ->
  #   model = entityUtil.get(@pathTab[index]).model
  #   if index == 0
  #     if @isOneType index + 2
  #       @callbackHandler req, res, next, model, index + 2
  #     else
  #       @callbackHandler req, res, next, model




  typeHandler: (req, res, next, index) ->
    if index < @pathTab.length
      if @isManyType index
        @manyTypeHandler ...
      else
        @oneTypeHandler ...
    else
      return null

  getById: (req, res, next) ->
    if @path?
      console.log @pathTab
      @callbackHandler req, res, next, 0
      # res.send @model.getName! + " " + @path
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
