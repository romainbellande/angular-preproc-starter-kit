let
  'use strict'
  window.angulatool =
    * service: null
      directive: null
      component: null
      setService: (func) ->
        @.service = func
      setDirective: (func) ->
        @.directive = func
      setComponent: (func) ->
        @.component = func

