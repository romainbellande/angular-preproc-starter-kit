'use strict'
class Controller
  (@schema) ->

  get: (req, res, next) ->
    @schema.find (err, data) ->
      next err if err?
      res.json data
  post: (req, res, next) ->
    data = new @schema req.body
    data.save (err) ->
      next err if err?
      res.status 200

