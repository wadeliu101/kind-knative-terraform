const config = require('../services/config')

module.exports = {
  port: config.port,
  db: require('./db'),
}
