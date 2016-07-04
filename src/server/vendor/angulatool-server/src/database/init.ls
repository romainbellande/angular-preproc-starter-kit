logger = require \../utils/logger/logger
'use strict'
require! \mongoose
export class Db
  (name) ->
    mongoose.connect do
      "mongodb://localhost/#{name}"
      (err) ->
        if err?
          logger.error "db #{name}: connection error. #{err}"
        else
          logger.info "db #{name}: connection successfull"

