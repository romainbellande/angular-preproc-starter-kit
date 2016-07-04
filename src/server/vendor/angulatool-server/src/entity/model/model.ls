'use strict'
require! \mongoose
Schema = mongoose.Schema
modelList = []

export class Model
  (schemaName, data, dep) ->
    @schemaName = schemaName
    @data = data
    if dep?
      if dep.has_one?
        @data[dep.has_one] = {type: mongoose.Schema.Types.ObjectId, ref: dep.has_one}
    mySchema = new Schema @data
    @schema = mongoose.model @schemaName, mySchema
  getSchema: ~> @schema
  getName: ~> @schemaName
