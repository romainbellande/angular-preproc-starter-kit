'use strict'
Controller = (require \./controller).Controller
export class HasOneController extends Controller
  (@model, @parentModel, @options) ->
    @selector = {}
    @selector[@model.schemaName] = 1
    super ...

  get: (req, res, next) ->
    @parentModel.schema.findById do
      req.params["#{@parentModel.getName!}_id"]
      @selector
      (err, parent) ~>
        return next err if err?
        @schema.findById do
          parent[@model.schemaName]
          (err, child) ->
            console.log child
            return next err if err?
            res.json child

  post: (req, res, next) ->
    data = new @schema
    for key, value  of req.body
      data[key] = value
    data.save (err, child) ~>
      next err if err?
      putItem = {}
      putItem[@model.schemaName] = child._id
      @parentModel.schema.findOneAndUpdate do
        _id: req.params["#{@parentModel.getName!}_id"]
        {$set: putItem}
        {new: true}
        (err, parent) ->
          return next err if err?
          res.send parent

  delete: (req, res, next) ->
    if @options.child? and @options.child
      @parentModel.schema.findOneAndUpdate do
        req.params["#{@parentModel.getName!}_id"]
        {$unset: @selector}
        (err, parent) ~>
          return res.send err if err?
          @schema.remove do
            * _id: parent[@model.schemaName]
            (err, child) ->
              return next err if err?
              res.sendStatus 200
    else
      @parentModel.schema.findById do
        req.params["#{@parentModel.getName!}_id"]
        @selector
        (err, parent) ~>
          res.send err if err?
          @schema.remove do
            * _id: parent[@model.schemaName]
            (err, child) ->
              return next err if err?
              res.sendStatus 200

