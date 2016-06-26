module.exports = phantomjs;

function phantomjs(){
  var path = require('path');
  var phantomjs = require('phantomjs');
  process.env.PHANTOMJS_BIN = phantomjs.path;
}
