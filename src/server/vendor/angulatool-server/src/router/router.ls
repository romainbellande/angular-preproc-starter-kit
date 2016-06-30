'use strict'
require! \express
require! \fs
routeTable = require \./routeTable
router = express.Router!
Model = new (require \../database/model).Model
Controller = new (require \../database/controller).Controller
export class Router
  create: (routeName, data) ->
    entity = Model.create routeName, data
    router.route "/#{routeName}"
      .get (req, res, next) ->
        res.send "[GET] #{routeName}"
      .post (req, res, next) ->
        res.send "[POST] #{routeName}"
    router.route "/#{routeName}/:#{routeName}_id"
      .get (req, res, next) ->
        res.send "[GET] #{routeName}/:#{routeName}_id"
      .put (req, res, next) ->
        res.send "[PUT] #{routeName}/:#{routeName}_id"
      .delete (req, res, next) ->
        res.send "[DELETE] #{routeName}/:#{routeName}_id"

    routeTable "/#{routeName}", router.stack
    router
