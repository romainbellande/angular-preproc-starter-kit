'use strict'
createRoute = (routeName) ->
  express = require \express
  router = express.Router!
  router.get \/, (req, res, next) ->
    res.send '[GET] ' + routeName

exports.createRoute = createRoute
