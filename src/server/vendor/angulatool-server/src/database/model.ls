'use strict'
require! \mongoose
Schema = mongoose.Schema
export class Model
  (schemaName, data) ->
    myShema = new Schema data
    mongoose.model schemaName, myShema
