# TO create a new directive, simply pu the code below

# new angulatool.component (
#   name: \home
#   inject: []
#   template: ''
#   func: ($scope, $elements, $attrs)->
# )
'use strict'
require! {
  \prelude-ls
}

window import prelude-ls

component = (...args) ->

  @name = args.0
  @callback = args.1[\callback]
  @template = args.1[\template]

  @base = (template, controller) ->
    * template: template
      controller: controller

  @init = ~>
    (angular.module \app.components)
      .component @name, @base(@template, @callback)
  @init?!

angulatool.setComponent component
