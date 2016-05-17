'use strict'
require! {
  \prelude-ls
}

window import prelude-ls

window.angulatool = let
  directive : (name, template, callback) ->
    nameCapitalized = capitalize(name)
    @func = (window[nameCapitalized + \Service]) ->
      params =
        link: link
        restrict: \E
        template: template

      link = (scope, elements, attrs) !->
        eval \scope. + nameCapitalized + 'Service = ' + nameCapitalized + \Service
        if callback
          callback()

    @func.$inject = [
      nameCapitalized + \Service
    ]

    module = (angular.module \app.directives).directive name, @func
    module
