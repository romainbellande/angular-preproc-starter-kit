module.exports = (baseUrl, routes) ->
  cliTable = require 'cli-table'
  table = new cliTable {head: ['', 'Path']}
  console.log '\nAPI for ' + baseUrl
  console.log '\n********************************************'
  for key of routes
    if routes.hasOwnProperty key
      val = routes[key]
      # if val.route && (val.route.path.indexOf baseUrl) == 0
      if val.route
        val = val.route
        for key2 of val.stack
          tmp = {}
          tmp[val.stack[key2].method] = baseUrl + val.path
          table.push tmp


  console.log table.toString!
  table
