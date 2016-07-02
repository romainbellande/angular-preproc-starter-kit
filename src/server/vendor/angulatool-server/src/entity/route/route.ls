'use strict'
require! \express
require! \fs
routeTable = require \../../router/routeTable
router = express.Router!
export class Route
  (routeName, controller, behaviors, dep) ~>
    route = []
    route[\all] = router.route "/#{routeName}"
      .get controller.get
      .post controller.post

    route[\uniq] = router.route "/#{routeName}/:#{routeName}_id"
      .get controller.getById
      .put controller.put
      .delete controller.delete

    if behaviors?
      for behavior in behaviors
        isBehaviorRouteCreated = false
        route[\behavior] = ""
        if !isBehaviorRouteCreated
          route[\behavior] = router.route "/#{routeName}/:#{routeName}_id/#{behavior.getName!}"
          isBehaviorRouteCreated = true
        route[\behavior].get behavior.get


    routeTable "/#{routeName}", router.stack
    @route = router
  getRoute: ~> @route
