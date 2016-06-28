(function(){
  var program, myPackage, lintFiles, reportTotal, reportError;
  program = require('commander');
  myPackage = require('../package.json');
  lintFiles = require('./lint-files');
  reportTotal = require('./reporters/report-total');
  reportError = require('./reporters/report-error');
  module.exports = function(argv){
    program.version(myPackage.version).parse(process.argv);
    if (program.args.length === 0) {
      program.help();
      process.exit(1);
    }
    return function(it){
      return it.then(function(){
        return process.exit(1);
      });
    }(
    function(it){
      return it['catch'](reportError);
    }(
    function(it){
      return it.then(function(content){
        console.log(content.length);
        return process.exit(1);
      });
    }(
    function(it){
      return it.then(reportTotal);
    }(
    lintFiles(
    program.args)))));
  };
}).call(this);
