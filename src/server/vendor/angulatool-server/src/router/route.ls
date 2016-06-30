'use strict'
require! \express
require! \fs
routeTable = require \./routeTable
router = express.Router!
Model = (require \../database/model).Model
Controller = (require \../database/controller).Controller
export class Route
  @route = null
  (routeName, data) ->
    entity = new Model routeName, data
    controller = new Controller entity
    router.route "/#{routeName}"
      .get controller.get
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
    @route = router
