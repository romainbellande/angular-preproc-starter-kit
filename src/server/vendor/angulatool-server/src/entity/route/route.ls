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
    # Express Middleware
    if @isRoot
      app.use (req, res, next) ->
        console.log \middleware

    routeTable "/#{routeName}", @route.stack if @isRoot
    @route = router

  getRoute: -> @route

  behaviorHandler: (behaviors) ->
    behaviorsList = []
    if behaviors?
      for behavior in behaviors
        behaviorsList.push behavior

  depHandler: (dep) ->
    if @isRoot
      @paths.isRoot = true
    if dep?
      if dep.has?one?
        for hasOneDep, k_hasOneDep in dep.has.one
          myDep = (entity.get hasOneDep.0).routeClass.paths
          myDep.opt = hasOneDep.1
          myDep.type = \has_one
          @paths.dep[k_hasOneDep] = myDep
    @readPaths @paths
    if @isRoot
      @writePaths!
      logger.info "[#{@routeName} PATHS]".toUpperCase!
      _pathsTreeMsg = {}
      for k, path of @pathsTree
        _pathsTreeMsg["path_#{k}"] = "\"#{path}\" registered..."
      logger.box _pathsTreeMsg


  writePaths: ->

    isLeaf = (index) ~>
      @pathsTree.length == index + 1
    isRoot = (index) ->
      index == 0
    isRootId = (index) ->
      isRoot index - 1 && index == 1

    for path, k in @pathsTree
      pathTab = path.substring(1).split \/
      if isRoot k
        @route.route path
          .get @controller~get
          .post @controller~post

      else if isRootId k
        @route.route path
          .get @controller~getById
          .put @controller~put
          .delete @controller~delete

      else
        console.log path
        depController = new Controller @model, path
        @route.route path
          .get depController~getById



  readPaths: (paths, parent) ->
    parentTmp = void

    if parent?
      if paths.type == \has_one
        @pathsTree.push parent + paths.root
        parentTmp = parent + paths.root
      else
        @pathsTree.push parent + paths.root
        @pathsTree.push parent + paths.root + paths.id
        parentTmp = parent + paths.root + paths.id
    else if paths.isRoot
      @pathsTree.push paths.root
      @pathsTree.push paths.root + paths.id
      parentTmp = paths.root + paths.id
    if @pathsTree.length > 0
      # console.log "@pathsTree [#{@routeName}]", @pathsTree
      for k, dep of paths.dep
        @readPaths dep, parentTmp if paths.dep?





