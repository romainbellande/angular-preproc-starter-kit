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
    @controller = new Controller @model


    @paths =
      root: "/#{@routeName}"
      id: "/:#{@routeName}_id"
      dep: {}

    isRouterBegin = router.stack === []
    routeList = []
    @isRoot = !dep?root? or dep.root

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

  depHandler: (dep) ->
    if @isRoot
      @paths.isRoot = true
      @route.route @paths.root
        .get @controller~get
        .post @controller~post

      @route.route @paths.root + @paths.id
        .get @controller~getById
        .put @controller~put
        .delete @controller~delete
    if dep?
      if dep.has?one?
        for hasOneDep, k_hasOneDep in dep.has.one
          myDep = (entity.get hasOneDep.0).routeClass.paths
          myDep.opt = hasOneDep.1
          myDep.type = \has_one
          @paths.dep[k_hasOneDep] = myDep
        @readPath @paths

  readPath: (paths, parent) ->
    console.log \paths, paths
    parentTmp = void
    if paths.isRoot
      console.log paths.root
      console.log paths.root + paths.id
      parentTmp = paths.root + paths.id
    else if parent?
      if paths.type == \has_one
        console.log parent + paths.root
        parentTmp = paths.root
      else
        console.log parent + paths.root
        console.log parent + paths.root + paths.id
        parentTmp = paths.root + paths.id

    @readPath paths.dep, parentTmp if paths.dep?

