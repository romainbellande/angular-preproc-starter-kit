'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
HasOneController = (require \../controller/hasOneController).HasOneController
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
logger = require \../../utils/logger/logger
export class Route
  (@routeName, @model, behaviors, data) ->
    @dep = data.dep
    if data.plural?
      @plural = data.plural
    else
      @plural = "#{@routeName}s"

    @controller = new Controller @model
    @pathsTree = []

    @paths =
      name:
        sing: @routeName
        plur: @plural
      dep: {}

    @router = express.Router!
    isRouterBegin = @router.stack === []
    routeList = []
    @isRoot = !@dep?root? or @dep.root
    # @behaviorHandler behaviors
    @depHandler @dep
    console.log \paths, @paths
    if @isRoot || !@paths.isRoot
      @createManyRoute @router, @controller, @paths.name.sing, @paths.name.plur



  getRoute: -> @router

  behaviorHandler: (behaviors) ->
    behaviorsList = []
    if behaviors?
      for behavior in behaviors
        behaviorsList.push behavior

  createManyRoute: (router, controller, singName, plurName) ->
    router.route \/
      .get controller~get
      .post controller~post

    router.route "/:#{singName}_id"
      .get controller~getById
      .put controller~put
      .delete controller~delete

    app.use "/api/#{plurName}", router
    routeTable plurName, router.stack


  depHandler: (dep) ->
    if @isRoot
      @paths.isRoot = true
    if dep?
      if dep.has?one?
        for depValue, depKey in dep.has.one
          depRouter = express.Router {mergeParams: true}
          depController = new HasOneController (entity.get depValue.0).model, @model, depValue.1
          depRouter.route \/
            .get depController~get
            .post depController~post
            .delete depController~delete
          depManyRouter = express.Router!
          depManyController = new Controller (entity.get depValue.0).model
          depNames = (entity.get depValue.0).routeClass.paths.name;

          # if @paths.isRoot? && @paths.isRoot
          @router.use "/:#{@routeName}_id/#{depValue.0}", depRouter
          console.log \globalRouter, "/:#{@routeName}_id/#{depValue.0}"
          # else
          #   @router.use "/:#{@routeName}_id/#{depValue.0}", depRouter
          #   console.log \manyRouter, "/:#{@routeName}_id/#{depValue.0}"

          # @createManyRoute depManyRouter, depManyController, depNames.sing, depNames.plur
      if dep.has?many?
        for value, key in dep.has.one
          depRouter = express.Router {mergeParams: true}
          @router.use "/:#{@routeName}_id/#{value.0}", depRouter
