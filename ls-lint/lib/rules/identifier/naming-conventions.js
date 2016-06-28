(function(){
  var rule, message, ref$, map, filter, pairsToObj, any, Obj, camelize, capitalize, parseRules, getCheckers, isNonAscii, isQuoted, isIgnore, isPascal, isCamel, isChain, isSnake, isUpperSnake;
  rule = 'naming-conventions';
  message = function(type, name, value){
    return type + " '" + name + "' should be " + value + ".";
  };
  ref$ = require('prelude-ls'), map = ref$.map, filter = ref$.filter, pairsToObj = ref$.pairsToObj, any = ref$.any, Obj = ref$.Obj, camelize = ref$.camelize, capitalize = ref$.capitalize;
  module.exports = function(config){
    var ref$, level, value, namingRules;
    ref$ = config[camelize(rule)], level = ref$.level, value = ref$.value;
    if (level !== 'ignore') {
      namingRules = parseRules(value);
      return function(id){
        var namingRule;
        namingRule = namingRules[id.type];
        if (!any((function(it){
          return it(id.name);
        }), namingRule.func)) {
          return {
            rule: rule,
            line: id.line + 1,
            column: id.column + 1,
            level: level,
            message: message(capitalize(id.type), id.name, namingRule.value)
          };
        }
      };
    } else {
      return function(){};
    }
  };
  parseRules = function(it){
    return Obj.map(function(value){
      return {
        value: value,
        func: getCheckers(value)
      };
    })(
    it);
  };
  getCheckers = function(value){
    if (value === 'ignore') {
      return [function(){
        return true;
      }];
    } else {
      return filter((function(it){
        return it(value);
      }))(
      [isPascal, isCamel, isChain, isSnake, isUpperSnake]);
    }
  };
  isNonAscii = (function(it){
    return /[^\x01-\x7e]/.exec(it);
  });
  isQuoted = (function(it){
    return /^".*"$|^'.*'$/.exec(it);
  });
  isIgnore = function(it){
    return isNonAscii(it) || isQuoted(it);
  };
  isPascal = function(it){
    return isIgnore(it) || /^[A-Z][A-Za-z0-9]*$/.exec(it);
  };
  isCamel = function(it){
    return isIgnore(it) || /^[a-z][A-Za-z0-9]*$/.exec(it);
  };
  isChain = function(it){
    return isIgnore(it) || /^[a-z][a-z0-9-]*$/.exec(it);
  };
  isSnake = function(it){
    return isIgnore(it) || /^[a-z][a-z0-9_]*$/.exec(it);
  };
  isUpperSnake = function(it){
    return isIgnore(it) || /^[A-Z][A-Z0-9_]*$/.exec(it);
  };
}).call(this);
