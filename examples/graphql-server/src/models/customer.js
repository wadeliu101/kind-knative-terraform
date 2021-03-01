const { DataTypes, Model } = require('sequelize');
const { db } = require('../config/index');

class Customer extends Model {};

Customer.init({
  // Model attributes are defined here
  customerNumber: {
    type: DataTypes.BIGINT(11),
    allowNull: false,
    primaryKey: true,
  },
  customerName: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  contactLastName: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  contactFirstName: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  phone: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  addressLine1: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  addressLine2: {
    type: DataTypes.STRING(50),
  },
  city: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  state: {
    type: DataTypes.STRING(50),
  },
  postalCode: {
    type: DataTypes.STRING(50),
  },
  country: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  salesRepEmployeeNumber: {
    type: DataTypes.BIGINT(11),
  },
  creditLimit: {
    type: DataTypes.DECIMAL(10,2)
  }
}, {
  sequelize: db,
  tableName: 'customers',
  timestamps: false,
});

module.exports = Customer;