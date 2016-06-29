(function(){
  var fs, path, loadLson, loadOptionalLson, configFile, defaultConfig, currentConfig;
  fs = require('fs');
  path = require('path');
  loadLson = require('./load-lson');
  module.exports = function(opts){
    var configFile, ref$, requestConfig, optsConfig;
    configFile = (ref$ = opts.configFile) != null
      ? ref$
      : opts.ruleFile;
    requestConfig = configFile
      ? loadLson(configFile)
      : {};
    optsConfig = (ref$ = opts.config) != null
      ? ref$
      : {};
    return import$(import$(import$(import$({}, defaultConfig), currentConfig), requestConfig), optsConfig);
  };
  loadOptionalLson = function(lsonFile){
    var e;
    try {
      fs.accessSync(lsonFile, fs.R_OK);
    } catch (e$) {
      e = e$;
      return {};
    }
    return loadLson(lsonFile);
  };
  configFile = 'ls-lint.lson';
  defaultConfig = loadLson(
  path.resolve(path.dirname(
  module.filename), "../" + configFile));
  currentConfig = loadOptionalLson("./" + configFile);
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
