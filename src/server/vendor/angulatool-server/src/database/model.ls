'use strict'
require! \mongoose
Schema = mongoose.Schema
create = (schemaName, data) ->
  myShema = new Schema data
  mongoose.model schemaName, myShema
export create
