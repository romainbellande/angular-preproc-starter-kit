'use strict'
Model = (require \../database/model).Model
Controller = (require \../database/controller).Controller
Route = (require \../router/route).Route

export class Entity

  (name, data) ->
    @name = name
    _model = new Model @name, data
    _controller = new Controller _model
    _route = new Route @name, _controller
    @route = _route.getRoute!
  getRoute: ~> @route
