let
  'use strict'
  window.angulatool =
    * service: null
      directive: null
      setService: (func) ->
        @.service = func
      setDirective: (func) ->
        @.directive = func

