'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
routeTable = require \../../router/routeTable
router = express.Router!
export class Route
  (routeName, controller, behaviors, dep) ~>
    @route = router
    @routeName = routeName
    @controller = controller
    isRouterBegin = router.stack === []
    routeList = []
    isRoot = !dep?root? or dep.root
    if isRoot
      routeList[\all] = @route.route "/#{@routeName}"
        .get @controller.get
        .post @controller.post

      routeList[\uniq] = @route.route "/#{@routeName}/:#{@routeName}_id"
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
        console.log "dep: #{dep.has_one}"
        console.log \depName2 (entity.get dep.has_one).name
        @route.route "/#{@routeName}/:#{@routeName}_id/#{dep.has_one}"
          .get @controller.getById
          .put @controller.put
          .delete @controller.delete


