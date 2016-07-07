'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
HasOneController = (require \../controller/hasOneController).HasOneController
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
router = express.Router!
export class Route
  (@routeName, @model, behaviors, dep) ->
    @route = router
    if @isRoot
      @controller = new Controller @model
    else if dep?
      if dep.has?one?
        @controller = new HasOneController myDep.model, @model, hasOneDep.1
    @paths = {
      path: "/#{@routeName}",
      ctrl: @controller
      dep: {}
    }
    isRouterBegin = router.stack === []
    routeList = []
    @isRoot = !dep?root? or dep.root
    if @isRoot
      controller = new Controller @model
      routeList[\one] = @route.route @paths.one
        .get controller~get
        .post controller~post

      routeList[\many] = @route.route @paths.many
        .get controller~getById
        .put controller~put
        .delete controller~delete

    @depHandler dep

    if behaviors?
      for behavior in behaviors
        isBehaviorRouteCreated = false
        routeList[\behavior] = ""
        if !isBehaviorRouteCreated
          routeList[\behavior] = @route.route "#{@paths.many}/#{behavior.getName!}"
          isBehaviorRouteCreated = true
        routeList[\behavior].get behavior.get

    app.use @route
    routeTable "/#{routeName}", @route.stack if @isRoot
    @route = router
  getRoute: -> @route

  readPath: (paths) ->
    console.log paths.path
    readPath paths.dep.path if paths.dep?

  depHandler: (dep) ->
    if dep?
      if dep.has?one?
        for hasOneDep in dep.has?one

          myDep = entity.get hasOneDep.0
          hasOneController = new HasOneController myDep.model, @model, hasOneDep.1
          depPaths = myDep.routeClass.paths.dep

          (Object.keys depPaths).map (value, key) ->
            myDep.routeClass.paths.one ++ depPaths[value]

          @paths.dep[myDep.name] = myDep.routeClass.paths

          if @isRoot
            @paths.dep = myDep.routeClass.paths
            # @route.route @paths.path
            #   .post hasOneController~post
            #   .get hasOneController~get
            #   .put hasOneController~put
            #   .delete hasOneController~delete
            @route.route @paths.path
              .get controller~get
              .post controller~post

            @route.route @paths.path + @paths.path + "_id"
              .get controller~getById
              .put controller~put
              .delete controller~delete
        # @route.route "/#{@routeName}/:#{@routeName}_id/#{dep.has_one}"



