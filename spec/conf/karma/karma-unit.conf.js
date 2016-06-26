var sharedConfig = require('../karma.conf');

module.exports = function(config) {
  var conf = sharedConfig();

  conf.files = conf.files.concat([
    //test files
    'client/**/*Spec.js'
  ]);

  config.set(conf);
};
