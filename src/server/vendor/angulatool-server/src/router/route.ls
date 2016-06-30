'use strict'
require! \express
require! \fs
routeTable = require \./routeTable
router = express.Router!
export class Route
  (routeName, controller) ~>
    router.route "/#{routeName}"
      .get controller.get
      .post controller.post
    router.route "/#{routeName}/:#{routeName}_id"
      .get controller.getById
      .put controller.put
      .delete controller.delete

    routeTable "/#{routeName}", router.stack
    @route = router
  getRoute: ~> @route
