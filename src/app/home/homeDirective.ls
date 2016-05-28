let
  'use strict'

  # @.func = (scope, elements, attrs) ->
  #   console.log Array.prototype.slice.call(arguments)

    # scope.HomeService = HomeService

  home = new angulatool.directive (
    name: \home
    inject: []
    template: ''
    callback: (scope, elements, attrs) ->
      console.log arguments
      # Array.prototype.slice.call(arguments).push <[scope elements attrs]> ++ @.inject
      scope.HomeService = HomeService

  )


