const { DataTypes, Model } = require('sequelize');
const { db } = require('../config/index');

class Payment extends Model {};

Payment.init({
  // Model attributes are defined here
  customerNumber: {
    type: DataTypes.BIGINT(11),
    allowNull: false,
    primaryKey: true,
  },
  checkNumber: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  paymentDate: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  amount: {
    type: DataTypes.DECIMAL(10,2),
    allowNull: false,
  }
}, {
  sequelize: db,
  tableName: 'payments',
  timestamps: false,
});

module.exports = Payment