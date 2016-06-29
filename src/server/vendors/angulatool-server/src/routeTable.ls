module.exports = (baseUrl, routes) ->
  Table = require 'cli-table'
  table = new Table {head: ['', 'Path']}
  console.log '\nAPI for ' + baseUrl
  console.log '\n********************************************'
  for key of routes
    if routes.hasOwnProperty key
      val = routes[key]
      if val.route
        val = val.route
        _n = {}
        _o = {}
        for key2 of val.stack
          tmp = {}
          tmp[val.stack[key2].method] = val.path
          table.push tmp


  console.log table.toString!
  table
