'use strict'
export class Controller
  (model) ->
    @model = model
    @schema = @model.getSchema!
  get: (req, res, next) ~>
    res.send "[GET] #{@model.getName!}"
    # @schema.find (err, data) ->
    #   next err if err?
    #   res.json data
    # res.send \test2
  post: (req, res, next) ~>
    res.send "[POST] #{@model.getName!}"
    # data = new @schema req.body
    # data.save (err) ->
    #   next err if err?
    #   res.status 200
  getById: (req, res, next) ~>
    res.send "[GET_BY_ID] #{@model.getName!}"

  put: (req, res, next) ~>
    res.send "[PUT] #{@model.getName!}"

  delete: (req, res, next) ~>
    res.send "[DELETE] #{@model.getName!}"
