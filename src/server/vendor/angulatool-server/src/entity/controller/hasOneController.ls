'use strict'
Controller = (require \./controller).Controller
export class HasOneController extends Controller
  (model, parentModel) ->
    super model
    @parentModel = parentModel

  has_one_post: (req, res, next) ~>
    data = new @schema
    for key, value  of req.body
      data[key] = value
    data.save (err, entity) ->
      next err if err?
      putItem = {}
      putItem[@model.schemaName] = entity._id
      @parentModel.schema.findOneAndUpdate do
        _id: req.params["#{@parentModel.getName!}_id"]
        {$set: putItem}
        {new: true}
        (err, entity) !->
          next err if err?
          res.send entity
      res.sendStatus 200
