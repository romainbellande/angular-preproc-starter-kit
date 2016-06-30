'use strict'
require! \mongoose
export class Db
  (name) ->
    mongoose.connect do
      "mongodb://localhost/#{name}"
      (err) ->
        if err?
          console.log "db #{name}: connection error", err
        else
          console.log "db #{name}: connection successfull"

