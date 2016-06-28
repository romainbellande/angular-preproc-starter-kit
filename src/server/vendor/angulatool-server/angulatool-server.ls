'use strict'
window.angulatool =
  * routing: null
    setRouting: (func) ->
      @routing = func
    getArgs: (func) ->
      args = (func.toString!.match //function\s.*?\(([^)]*)\)//).1
      ((args.split ',').map ((arg) -> (arg.replace //\/\*.*\*\///, '').trim!)).filter ((arg) -> arg)
