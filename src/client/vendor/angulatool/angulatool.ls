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
      getArgs: (func) ->
        args = (func.toString!.match //function\s.*?\(([^)]*)\)//).1
        ((args.split ',').map ((arg) -> (arg.replace //\/\*.*\*\///, '').trim!)).filter ((arg) -> arg)

