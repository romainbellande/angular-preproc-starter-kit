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

component = (params) ->
  @name = params.name
  # @inject = params.inject.scope ++ params.inject.self
  @callback = params.callback

  # @base = (template, callback) ->
  #   injectTab = params.inject.scope ++ capitalize(params.name) + \Service
  #   * template: template
  #     bindings: {}
  #     controller: ($scope) ~>
  #       for toInjectInScope, i in injectTab
  #         $scope[toInjectInScope] = injectTab[i]
  #       for toInjectInSelf, j in params.inject.self
  #         @[toInjectInSelf] = params.inject.self[j]
  #       callback ...
  @base = (template, controller) ->
    * template: template
      controller: controller


  @init = ->
    console.log 'init component'
    (angular.module \app.components).component params.name, @base(params.template, @callback)
  @init?!

angulatool.setComponent component
