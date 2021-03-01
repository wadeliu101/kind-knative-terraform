const Payment = require('./payment')
const Customer = require('./customer')
const User = require('./user')

Payment.hasOne(Customer, {
  foreignKey: 'customerNumber',
  onDelete: 'RESTRICT',
  onUpdate: 'RESTRICT',
})
Customer.belongsTo(Payment, {
  foreignKey: 'customerNumber',
  onDelete: 'RESTRICT',
  onUpdate: 'RESTRICT',
})

module.exports = {
  Payment, 
  Customer,
  User,
}