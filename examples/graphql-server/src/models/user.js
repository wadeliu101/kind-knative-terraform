const { DataTypes, Model } = require('sequelize');
const { db } = require('../config/index');

class User extends Model {
  hasRole(role) {
    return this.role == role;
  }
};

User.init({
  username: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  password: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  role: {
    type: DataTypes.ENUM,
    values: ['ADMIN', 'USER', 'UNKNOWN'],
    allowNull: false,
  },
}, {
  sequelize: db,
  tableName: 'users',
  timestamps: false,
  indexes: [{ unique: true, fields: ['username', 'password'] }]
});

(async (User) => {
  await User.sync({ force: true });
  console.log("The table for the User model was just (re)created!");
  User.create({
    username: 'admin',
    password: 'admin',
    role: 'ADMIN',
  })
})(User)

module.exports = User