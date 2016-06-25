# TO create a new directive, simply pu the code below

# new angulatool.directive (
#   name: \home
#   inject: []
#   template: ''
#   func: (scope, elements, attrs)->
# )
'use strict'
require! {
  \prelude-ls
}

window import prelude-ls

component = (params) ->
  @name = params.name
  @inject = params.inject.scope ++ params.inject.self
  @callback = params.callback

  @base = (template, controller) ->
    (...args) ~>
      args = args |> filter (.0 isnt \$)
      controller: ($scope) ~>
        for toInjectInScope, i in params.inject.scope ++ capitalize(params.name) + "Service"
          $scope[toInjectInScope] = args[i]
        for toInjectInSelf, j in params.inject.self
          @[toInjectInSelf] = args[j]
        controller ...
      template: template

  @init = ->
    console.log 'init component'
    (angular.module \app.components).component params.name, @inject ++ [@base(params.template, @callback)]

  @init?!

angulatool.setComponent component
