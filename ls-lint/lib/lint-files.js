(function(){
  var globAll, fs, ref$, map, flatten, empty, lsLint, reportLintFile, lintFile;
  globAll = require('glob-all');
  fs = require('fs');
  ref$ = require('prelude-ls'), map = ref$.map, flatten = ref$.flatten, empty = ref$.empty;
  lsLint = require('./ls-lint');
  reportLintFile = require('./reporters/report-lint-file');
  module.exports = function(paths){
    return function(it){
      return it.then(flatten);
    }(
    Promise.all(
    map(lintFile)(
    globAll.sync(paths))));
  };
  lintFile = function(file, opts){
    return new Promise(function(resolve, reject){
      return fs.readFile(file, {
        encoding: 'utf8'
      }, function(err, data){
        if (err) {
          return reject(err);
        } else {
          return resolve(
          reportLintFile(file)(
          lsLint.lint(data, opts)));
        }
      });
    });
  };
}).call(this);
