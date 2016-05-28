
let
  'use strict'
  require! {
    \prelude-ls
  }

  window import prelude-ls

  directive = (params) ->
    @.name = params.name
    @.inject = params.inject ++ capitalize(params.name) + "Service"
    @.func = params.func
    console.log @.func.prototype

    @.base = (template, link) ->
      ->
        params =
          link: link
          restrict: \E
          template: template

    @.init = ->
      console.log @.inject ++ @.base(params.template, @.func)
      @.injection?!
      (angular.module \app.directives).directive params.name, @.inject ++ @.base(params.template, @.func)


    @.init?!
  angulatool.setDirective directive



