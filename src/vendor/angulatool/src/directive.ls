# TO create a new directive, simply pu the code below

# new angulatool.directive (
#   name: \home
#   inject: []
#   template: ''
#   func: (scope, elements, attrs)->
# )

let
  'use strict'
  require! {
    \prelude-ls
  }

  window import prelude-ls

  directive = (params) ->
    @name = params.name
    @inject = params.inject.scope ++ params.inject.self
    @callback = params.callback

    @base = (template, link) ->
      (...args) ~>
        args = args |> filter (.0 isnt \$)
        link: (scope) ~>
          for toInjectInScope, i in params.inject.scope ++ capitalize(params.name) + "Service"
            scope[toInjectInScope] = args[i]
          for toInjectInThis, j in params.inject.self
            @[toInjectInThis] = args[j]
          link ...
        restrict: \E
        template: template

    @init = ->
      console.log 'init directive'
      (angular.module \app.directives).directive params.name, @inject ++ [@base(params.template, @callback)]

    @init?!

  angulatool.setDirective directive
