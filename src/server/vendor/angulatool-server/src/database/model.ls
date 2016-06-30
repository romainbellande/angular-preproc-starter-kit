'use strict'
require! \mongoose
Schema = mongoose.Schema
export class Model
  (schemaName, data) ->
    @schemaName = schemaName
    @data = data
    mySchema = new Schema @data
    @schema = mongoose.model @schemaName, mySchema
  getSchema: ~> @schema
  getName: ~> @schemaName
