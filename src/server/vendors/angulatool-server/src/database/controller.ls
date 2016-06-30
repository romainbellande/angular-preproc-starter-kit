'use strict'
class Controller
  (@schema) ->
    this
  get: (req, res, next) ->
    @schema.find <| (err, data) ->
      if err
        next err
      res.json data
  post: (req, res, next) ->
    data = new @schema req.body
    data.save <| (err) ->
      if err
        next err
      res.status 200

