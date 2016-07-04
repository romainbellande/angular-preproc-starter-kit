require! \fs
path_module = require \path
module_holder = {};

LoadModules = (path, recursive) ->
  fs.lstatSync path, (err, stat) ->
    if stat.isDirectory! and recursive? and recursive
      fs.readdirSync path, (err, files) ->
        f = void
        l = files.length
        i = 0
        while i < l
          f = path_module.join path, files[i]
          LoadModules f
          i++
    else
      (require path) module_holder
DIR = path_module.join __dirname, \../../../../entities
LoadModules DIR
