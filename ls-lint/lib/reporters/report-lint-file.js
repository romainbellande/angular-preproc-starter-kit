(function(){
  var ref$, each, map, filter, fold1, countBy, levelMark, levelValue, println, formatLintResult;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, fold1 = ref$.fold1, countBy = ref$.countBy;
  ref$ = require('./report-utils'), levelMark = ref$.levelMark, levelValue = ref$.levelValue, println = ref$.println;
  module.exports = curry$(function(file, results){
    var levelList;
    results == null && (results = []);
    if (results.length) {
      levelList = map(function(it){
        return it.level;
      })(
      results);
      (function(it){
        return println("    " + levelMark(it) + " " + file);
      })(
      fold1(function(x, y){
        if (levelValue(x > levelValue(y))) {
          return x;
        } else {
          return y;
        }
      })(
      levelList));
      each(function(it){
        return println("      " + formatLintResult(it));
      })(
      results);
      return countBy(function(it){
        return it;
      })(
      filter(function(it){
        return levelValue(it) > 0;
      })(
      levelList));
    } else {
      println("    " + levelMark('ok') + " " + file);
      return {};
    }
  });
  formatLintResult = function(it){
    var place;
    place = (function(){
      switch (false) {
      case it.line != null:
        return '';
      case it.column != null:
        return " (" + it.line + ")";
      default:
        return " (" + it.line + ":" + it.column + ")";
      }
    }());
    return levelMark(it.level) + " " + it.message + place;
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
