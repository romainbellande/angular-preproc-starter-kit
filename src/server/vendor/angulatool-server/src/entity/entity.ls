'use strict'
Model = (require \./model/model).Model
Controller = (require \./controller/controller).Controller
Route = (require \./route/route).Route
Behavior = (require \./controller/behavior).Behavior
logger = require \../utils/logger/logger

export get = (name) ->
  require "../../../../entities/#{name}/#{name}"

export class Entity

  (name, data) ->
    @name = name
    @model = new Model @name, data.attrs, data.dep
    isRoot = !data.dep?root? or data.dep.root
    if isRoot
      @controller = new Controller @model
    _behaviors = void
    /* Behaviors  handler*/
    if data.behaviors?
      _behaviors = @behaviorHandler data.behaviors

    @routeClass = new Route @name, @controller, _behaviors, data.dep
    @route = @routeClass.getRoute!

  getRoute: ~> @route
  depHandler : (dep) ~>
    if dep.has_one?
      console.log \dep:, dep.has_one.0


  behaviorHandler: (dataBehaviors) ~>
    _behaviors = []
    _behaviorsMsg = {}
    logger.info "[#{@name} behaviors]".toUpperCase!
    for let behavior, i in dataBehaviors
      _behaviorClass = void
      if behavior.2?
        _behaviorClass = new behavior.2 @model, behavior
        _behaviorsMsg["behavior_#{i}"] = "\"#{_behaviorClass.getName!}\" registered.."
      else
        _behaviorClass = new Behavior @model, behavior
      _behaviors.push _behaviorClass
    logger.box _behaviorsMsg
    _behaviors
