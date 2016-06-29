(function(){
  var lsc, ref$, Obj, Str, empty, map, compact, flatten, reject, split, last, initial, sortWith, loadConfig, loadRuleModules, lint, ruleModules, restructSrc, restructSrcLine, trimLast, compareColumn, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  lsc = require('livescript');
  ref$ = require('prelude-ls'), Obj = ref$.Obj, Str = ref$.Str, empty = ref$.empty, map = ref$.map, compact = ref$.compact, flatten = ref$.flatten, reject = ref$.reject, split = ref$.split, last = ref$.last, initial = ref$.initial, sortWith = ref$.sortWith;
  loadConfig = require('./load-config');
  loadRuleModules = require('./load-rule-modules');
  out$.lint = lint = function(src, opts){
    var lintTarget, e, result, ref$, message, line;
    opts == null && (opts = {});
    try {
      lintTarget = Obj.map((function(it){
        return it(src);
      }), {
        tokens: lsc.lex,
        ast: lsc.ast
      });
    } catch (e$) {
      e = e$;
      result = /(.*) on line (\d+)|(.*)/.exec(e.message);
      ref$ = result[1]
        ? [result[1], +result[2]]
        : [result[3], void 8], message = ref$[0], line = ref$[1];
      return [{
        rule: 'compile',
        level: 'fatal',
        line: line,
        message: message
      }];
    }
    lintTarget.src = src;
    lintTarget.lines = restructSrc(src);
    lintTarget.config = loadConfig(opts);
    return sortWith(function(x, y){
      switch (false) {
      case !(x.line > y.line):
        return 1;
      case !(x.line < y.line):
        return -1;
      default:
        return compareColumn(x, y);
      }
    })(
    reject(Obj.empty)(
    compact(
    flatten(
    map((function(it){
      return it(lintTarget);
    }))(
    ruleModules)))));
  };
  ruleModules = loadRuleModules(
  ['./rules/*.js']);
  restructSrc = function(it){
    return restructSrcLine(1)(
    trimLast(
    split(/(\r?\n)/)(
    it)));
  };
  restructSrcLine = curry$(function(line, arg$){
    var src, eol, cs;
    src = arg$[0], eol = arg$[1], cs = slice$.call(arg$, 2);
    return [{
      line: line,
      src: src,
      eol: eol
    }].concat(empty(cs)
      ? []
      : restructSrcLine(line + 1, cs));
  });
  trimLast = function(it){
    if (Str.empty(last(it))) {
      return initial(it);
    } else {
      return it;
    }
  };
  compareColumn = function(x, y){
    switch (false) {
    case !(x.column != null && y.column == null):
      return -1;
    case !(x.column == null && y.column != null):
      return 1;
    case !!(x.column != null && y.column != null):
      return 0;
    default:
      return x.column - y.column;
    }
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
