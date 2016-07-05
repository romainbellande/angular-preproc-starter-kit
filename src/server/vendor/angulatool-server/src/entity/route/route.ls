'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
router = express.Router!
export class Route
  (routeName, controller, behaviors, dep) ~>
    @route = router
    @routeName = routeName
    @paths = {
      all: "/#{@routeName}",
      uniq: "/#{@routeName}/:#{@routeName}_id"
    }
    @controller = controller
    isRouterBegin = router.stack === []
    routeList = []
    isRoot = !dep?root? or dep.root
    if isRoot
      routeList[\all] = @route.route @paths.all
        .get @controller.get
        .post @controller.post

      routeList[\uniq] = @route.route @paths.uniq
        .get @controller.getById
        .put @controller.put
        .delete @controller.delete

    @depHandler dep

    if behaviors?
      for behavior in behaviors
        isBehaviorRouteCreated = false
        routeList[\behavior] = ""
        if !isBehaviorRouteCreated
          routeList[\behavior] = @route.route "/#{@routeName}/:#{@routeName}_id/#{behavior.getName!}"
          isBehaviorRouteCreated = true
        routeList[\behavior].get behavior.get

    app.use @route
    routeTable "/#{routeName}", @route.stack if isRoot
    @route = router
  getRoute: ~> @route
  depHandler: (dep) ~>
    if dep?
      if dep.has_one?
        myDep = (entity.get dep.has_one)
        @route.route @paths.uniq + myDep.routeClass.paths.all
        hasOneController = new Controller myDep.model
        @route.route "/#{@routeName}/:#{@routeName}_id/#{dep.has_one}"
          .post hasOneController.post
          .get hasOneController.getById
          .put hasOneController.put
          .delete hasOneController.delete
    else



