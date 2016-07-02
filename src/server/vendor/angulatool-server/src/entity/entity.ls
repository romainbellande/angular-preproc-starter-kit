'use strict'
Model = (require \./model/model).Model
Controller = (require \./controller/controller).Controller
Route = (require \./route/route).Route
Behavior = (require \./controller/behavior).Behavior
logger = require \../utils/logger/logger

export class Entity

  (name, data) ->
    @name = name
    _model = new Model @name, data.attrs
    _controller = new Controller _model

    /* Behaviors  handler*/
    if data.behaviors?
      _behaviors = []
      _behaviorsMsg = {}
      logger.info "[#{@name} behaviors]".toUpperCase!
      for let behavior, i in data.behaviors
        _behaviorClass = void
        if behavior.2?
          _behaviorClass = new behavior.2 _model, behavior
          _behaviorsMsg["behavior_#{i}"] = "\"#{_behaviorClass.getName!}\" registered.."
        else
          _behaviorClass = new Behavior _model, behavior
        _behaviors.push _behaviorClass
      logger.box _behaviorsMsg
      _route = new Route @name, _controller, _behaviors
    else
      _route = new Route @name, _controller

    @route = _route.getRoute!
  getRoute: ~> @route
