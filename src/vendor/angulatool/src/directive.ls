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
    @.name = params.name
    @.inject = params.inject ++ capitalize(params.name) + "Service"
    @.callback = params.callback

    @.base = (template, link) ->
      ->
        params =
          link: link
          restrict: \E
          template: template

    # @.init = (scope, elements, attrs) ->
    #   console.log Array.prototype.slice.call(arguments)

    @.init = ->
      # console.log @.inject ++ @.base(params.template, @.callback)
      # @.callback.apply @, <[scope elements attrs]> ++ @.inject
      # console.log @.callback.prototype.slice.call(arguments)
      func = (inject, callback) ->
        # Array.prototype.slice.call(arguments).push  ++ inject
        callback.apply null, inject
        # callback inject

      (angular.module \app.directives).directive params.name, @.inject ++ @.base(params.template, func(@.inject, @.callback))

    @.init?!
  angulatool.setDirective directive



