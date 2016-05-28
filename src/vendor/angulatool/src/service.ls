# TO create a new directive, simply pu the code below

# new angulatool.service (
#   name: \nomComponent
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

  service = (params) ->
    @.name = params.name
    @.inject = params.inject ++ capitalize(params.name) + "Service"
    @.func = params.func

    @.init = ->
      console.log @.inject ++ @.base(params.template, @.func)
      @.injection?!
      (angular.module \app.services).service params.name, @.inject ++ @.func


    @.init?!
  angulatool.setService service



