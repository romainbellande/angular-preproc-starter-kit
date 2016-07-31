'use strict'
require! \mongoose
entityUtil = require \../entity
Schema = mongoose.Schema
modelList = []

export class Model
  (@name, @data, dep) ->
    if dep?
      if dep.has?one?
        for hasOneDep in dep.has.one
          @data[hasOneDep.0] = {type: mongoose.Schema.Types.ObjectId, ref: hasOneDep.0}
      if dep.has?many?
        for hasManyDep in dep.has.many
          plurName = (entityUtil.get hasManyDep.0).name.plural
          @data[plurName] = [{type: mongoose.Schema.Types.ObjectId, ref: hasOneDep.0}]
    mySchema = new Schema @data
    @schema = mongoose.model @name.singular, mySchema
