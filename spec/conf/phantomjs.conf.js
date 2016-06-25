function phantomjs(){
  var phantomjs = require('phantomjs');
  process.env.PHANTOMJS_BIN = phantomjs.path;
}

module.exports = phantomjs;
