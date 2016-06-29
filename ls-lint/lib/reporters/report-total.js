(function(){
  var ref$, map, fold, listsToObj, keys, join, sum, levelMark, levelValue, println, sumUp, worstMark;
  ref$ = require('prelude-ls'), map = ref$.map, fold = ref$.fold, listsToObj = ref$.listsToObj, keys = ref$.keys, join = ref$.join, sum = ref$.sum;
  ref$ = require('./report-utils'), levelMark = ref$.levelMark, levelValue = ref$.levelValue, println = ref$.println;
  module.exports = function(listOfTotals){
    var fileNum, fileNumStr;
    fileNum = listOfTotals.length;
    fileNumStr = fileNum + " file" + (fileNum !== 1 ? 's' : '');
    return println(
    function(it){
      var resultMarkStr, resultStr;
      resultMarkStr = worstMark(it);
      resultStr = join(', ')(
      map(function(level){
        var num;
        num = it[level];
        return num + " " + level + (num !== 1 ? 's' : '');
      })(
      keys(
      it)));
      console.log( "\n  " + resultMarkStr + " " + resultStr + " in " + fileNumStr + ".");
      if (resultMarkStr === levelMark('fatal') || resultMarkStr === levelMark('error')) {
        return process.exit(1);
      }
      else {
        return process.exit(0);
      }
    }(
    sumUp(['fatal', 'error', 'warning'])(
    listOfTotals)));
  };
  sumUp = curry$(function(targets, results){
    return listsToObj(targets)(
    map(function(target){
      return sum(
      map(function(it){
        var ref$;
        return (ref$ = it[target]) != null ? ref$ : 0;
      })(
      results));
    })(
    targets));
  });
  worstMark = function(result){
    return levelMark(
    fold(function(worst, level){
      if (result[level] > 0 && levelValue(level) > levelValue(worst)) {
        return level;
      } else {
        return worst;
      }
    }, 'ok')(
    keys(
    result)));
  };
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);
