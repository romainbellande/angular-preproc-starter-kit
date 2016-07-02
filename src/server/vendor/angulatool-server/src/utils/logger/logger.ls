config = require \./config.json
logger = require 'nicelogger' .config config.logger
module.exports = logger
