(function(){
  var ref$, levelMark, printerrln;
  ref$ = require('./report-utils'), levelMark = ref$.levelMark, printerrln = ref$.printerrln;
  module.exports = function(error){
    return printerrln(
    function(it){
      return "\n  " + levelMark('fatal') + " " + it;
    }(
    function(it){
      return it.toString();
    }(
    error)));
  };
}).call(this);
