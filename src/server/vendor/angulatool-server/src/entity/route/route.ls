'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
HasOneController = (require \../controller/hasOneController).HasOneController
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
router = express.Router!
export class Route
  (routeName, controller, behaviors, dep) ->
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
        .get @controller~get
        .post @controller~post

      routeList[\uniq] = @route.route @paths.uniq
        .get @controller~getById
        .put @controller~put
        .delete @controller~delete

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
  getRoute: -> @route
  depHandler: (dep) ->
    if dep?
      if dep.has_one?
        for hasOneDep in dep.has_one
          myDep = entity.get hasOneDep.0
          hasOneController = new HasOneController myDep.model, @controller.model, hasOneDep.1
          @route.route @paths.uniq + myDep.routeClass.paths.all
            .post hasOneController~post
            .get hasOneController~get
            .put hasOneController~put
            .delete hasOneController~delete
        # @route.route "/#{@routeName}/:#{@routeName}_id/#{dep.has_one}"



