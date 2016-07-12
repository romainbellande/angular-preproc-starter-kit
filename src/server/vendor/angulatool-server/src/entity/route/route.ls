'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
HasOneController = (require \../controller/hasOneController).HasOneController
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
logger = require \../../utils/logger/logger
router = express.Router!
export class Route
  (@routeName, @model, behaviors, dep) ->
    @route = router
    @controller = new Controller @model
    @pathsTree = []

    @paths =
      root: "/#{@routeName}"
      id: "/:#{@routeName}_id"
      dep: {}

    isRouterBegin = router.stack === []
    routeList = []
    @isRoot = !dep?root? or dep.root
    @behaviorHandler behaviors
    @depHandler dep

    app.use @route
    routeTable "/#{routeName}", @route.stack if @isRoot
    @route = router
  getRoute: -> @route
  behaviorHandler: (behaviors) ->
    behaviorsList = []
    if behaviors?
      for behavior in behaviors
        behaviorsList.push behavior
      # isBehaviorRouteCreated = false
      # routeList[\behavior] = ""
      # if !isBehaviorRouteCreated
      #   routeList[\behavior] = @route.route
        # isBehaviorRouteCreated = true
      # routeList[\behavior].get behavior.get
  depHandler: (dep) ->
    if @isRoot
      @paths.isRoot = true
      # @route.route @paths.root
      #   .get @controller~get
      #   .post @controller~post

      # @route.route @paths.root + @paths.id
      #   .get @controller~getById
      #   .put @controller~put
      #   .delete @controller~delete
    if dep?
      if dep.has?one?
        for hasOneDep, k_hasOneDep in dep.has.one
          myDep = (entity.get hasOneDep.0).routeClass.paths
          myDep.opt = hasOneDep.1
          myDep.type = \has_one
          @paths.dep[k_hasOneDep] = myDep
    @readPaths @paths
    if @isRoot
      logger.info "[#{@routeName} PATHS]".toUpperCase!
      _pathsTreeMsg = {}
      for k, path of @pathsTree
        _pathsTreeMsg["path_#{k}"] = "\"#{path}\" registered..."
      logger.box _pathsTreeMsg


  writePaths: (paths) ->
    for path of paths
      console.log path

  readPaths: (paths, parent) ->
    parentTmp = void
    if paths.isRoot
      @pathsTree.push paths.root
      @pathsTree.push paths.root + paths.id
      parentTmp = paths.root + paths.id
    else if parent?
      if paths.type == \has_one
        @pathsTree.push parent + paths.root
        parentTmp = parent + paths.root
      else
        @pathsTree.push parent + paths.root
        @pathsTree.push parent + paths.root + paths.id
        parentTmp = parent + paths.root + paths.id
    if @pathsTree.length > 0
      # console.log "@pathsTree [#{@routeName}]", @pathsTree
      for k, dep of paths.dep
        @readPaths dep, parentTmp if paths.dep?





