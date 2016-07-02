'use strict'
A = require \../../vendor/angulatool-server/angulatool-server
module.exports = class InfoBehavior extends A.Behavior
  ->
    super ...
  name: (req, res, next) ~>
    @sendParams req, res, next, \name
  info: (req, res, next) ~>
    console.log @schema.schema.path
    res.send @model.data
