'use strict'

require! \express
entity = require \../entity
app = (require \../../init)(\angulatool)
HasOneController = (require \../controller/hasOneController).HasOneController
HasManyController = (require \../controller/hasManyController).HasManyController
Controller = (require \../controller/controller).Controller
routeTable = require \../../router/routeTable
logger = require \../../utils/logger/logger
export class Route
  (@name, @model, behaviors, data) ->
    @dep = data.dep

    @controller = new Controller @model
    @pathsTree = []

    @paths =
      name: @name
      dep: {}
    @router = express.Router!
    isRouterBegin = @router.stack === []
    routeList = []
    @isRoot = !@dep?root? or @dep.root
    # @behaviorHandler behaviors
    @depHandler @dep
    if @isRoot || !@paths.isRoot
      @createManyRoute @router, @controller, @paths.name, true



  getRoute: -> @router

  behaviorHandler: (behaviors) ->
    behaviorsList = []
    if behaviors?
      for behavior in behaviors
        behaviorsList.push behavior

  createManyRoute: (router, controller, name, isRoot) ->
    router.route \/
      .get controller~get
      .post controller~post

    router.route "/:#{name.singular}_id"
      .get controller~getById
      .put controller~put
      .delete controller~delete
    if isRoot
      app.use "/api/#{name.plural}", router
    else
    return router
    routeTable name.plural, router.stack


  depHandler: (dep) ->
    if @isRoot
      @paths.isRoot = true
    if dep?

      if dep.has?one?
        for depValue, depKey in dep.has.one
          depRouter = express.Router {mergeParams: true}
          depController = new HasOneController do
            (entity.get depValue.0).model
            @model
            depValue.1
          depRouter.route \/
            .get depController~get
            .post depController~post
            .delete depController~delete
          depManyRouter = express.Router!
          depManyController = new Controller (entity.get depValue.0).model
          depNames = (entity.get depValue.0).name;
          @router.use "/:#{@name.singular}_id/#{depValue.0}", depRouter

      if dep.has?many?
        for manyValue, manyKey in dep.has.one
          depRouter = express.Router {mergeParams: true}
          depController = new HasManyController do
            (entity.get manyValue.0).model
            @model
            (entity.get manyValue.0).name
          @createManyRoute do
            depRouter
            depController
            (entity.get manyValue.0).name
            false
          @router.use "/:#{@name.singular}_id/#{(entity.get manyValue.0).name.plural}", depRouter
