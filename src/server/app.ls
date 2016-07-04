'use strict'
A = (require \./vendor/angulatool-server/angulatool-server)

app = A.init \angulatool
Dog = require \./entities/dog/dog
Meal = require \./entities/meal/meal
User = require \./entities/user/user

module.exports = app
