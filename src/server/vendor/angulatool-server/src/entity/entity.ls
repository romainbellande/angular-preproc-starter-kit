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

    _behaviors = void
    /* Behaviors  handler*/
    if data.behaviors?
      _behaviors = @behaviorHandler data.behaviors, \uniq if data.behaviors.uniq?
      _behaviors = @behaviorHandler data.behaviors, \all if data.behaviors.all?

    @routeClass = new Route @name, @model, _behaviors, data
    @route = @routeClass.getRoute!

  getRoute: ~> @route
  depHandler : (dep) ~>
    if dep.has?one?
      console.log \dep:, dep.has.one.0


  behaviorHandler: (dataBehaviors, type) ~>
    _behaviors = []
    _behaviorsMsg = {}
    logger.info "[#{@name} behaviors]".toUpperCase! + "[#{type}]".toUpperCase!
    if dataBehaviors.[type]?
      for let behavior, i in dataBehaviors[type]
        _behaviorClass = void
        if behavior.2?
          _behaviorClass = new behavior.2 @model, behavior
        else
          _behaviorClass = new Behavior @model, behavior
        _behaviorsMsg["behavior_#{i}"] = "\"#{_behaviorClass.getName!}\" registered.."
        _behaviors.push _behaviorClass
    logger.box _behaviorsMsg
    _behaviors
