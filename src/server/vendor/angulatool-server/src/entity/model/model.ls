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
        for hasOneDep in dep.has_one
          @data[hasOneDep.0] = {type: mongoose.Schema.Types.ObjectId, ref: hasOneDep.0}
    mySchema = new Schema @data
    @schema = mongoose.model @schemaName, mySchema
  getSchema: ~> @schema
  getName: ~> @schemaName
