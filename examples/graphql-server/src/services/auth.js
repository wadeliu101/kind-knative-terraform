const jwt = require('jsonwebtoken');
const { AuthenticationError } = require('apollo-server');
const {User: UserModel} = require('../models');

class Auth {
  constructor (model, jwt) {
    this.jwt = jwt
    this.model = model
    this.privateKey = 'shhhhh'
  }

  async login({ username, password }) {
    let user = await this.model.findOne({
      where: {
        username,
        password,
      }
    });
    return await this.jwt.sign({
      username: user.username,
      password: user.password,
    }, this.privateKey)
  }

  async verify(token) {
    let decoded;

    if (!token) {
      throw new AuthenticationError('miss token provided');
    }

    try {
      decoded = await this.jwt.verify(token, this.privateKey);
    } catch (err) {
      throw new AuthenticationError('token verify failure');
    }
    
    return await this.model.findOne({
      where: {
        username: decoded.username,
        password: decoded.password
      }
    })
  }
}

module.exports = new Auth(UserModel, jwt)