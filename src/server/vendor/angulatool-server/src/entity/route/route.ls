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
      root: "/#{@plural}"
      id: "/:#{@routeName}_id"
      dep: {}
    @router = express.Router!
    isRouterBegin = @router.stack === []
    routeList = []
    @isRoot = !@dep?root? or @dep.root
    # @behaviorHandler behaviors
    @depHandler @dep

    if @isRoot || @paths.type == \has_one
      @router.route \/
        .get @controller~get
        .post @controller~post

      @router.route @paths.id
        .get @controller~getById
        .put @controller~put
        .delete @controller~delete

      app.use "/api#{@paths.root}", @router

    routeTable @paths.root, @router.stack if @isRoot

  getRoute: -> @router

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
        for value, key in dep.has.one
          depRouter = express.Router {mergeParams: true}
          @router.use "/:#{@routeName}_id/#{value.0}", depRouter
          routeFunc = (req, res, next) ~> res.send "/:#{@routeName}_id/#{value.0}"
          depRouter.route \/
            .get routeFunc
            .post routeFunc
          console.log "dep #{key}: ", value
