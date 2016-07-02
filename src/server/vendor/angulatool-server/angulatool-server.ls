'use strict'
exports.init = require \./src/init
logger = require \./src/utils/logger/logger
logger.welcome!
exports.Entity = (require \./src/entity/entity).Entity
exports.routeTable = require \./src/router/routeTable
exports.Db = (require \./src/database/init).Db
exports.Behavior = (require \./src/entity/controller/behavior).Behavior
