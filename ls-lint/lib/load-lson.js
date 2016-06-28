(function(){
  var fs, lsc, Func;
  fs = require('fs');
  lsc = require('livescript');
  Func = require('prelude-ls').Func;
  module.exports = Func.memoize(function(lsonFile){
    return JSON.parse(
    lsc.compile(fs.readFileSync(lsonFile, {
      encoding: 'utf8'
    }), {
      json: true
    }));
  });
}).call(this);
