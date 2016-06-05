express = require \express
router = express.Router()

/* GET home page. */
router.get \/ , (req, res, next) ->
  res.render \../client/index.html

module.exports = router;
