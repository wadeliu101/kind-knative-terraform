const {Customer: CustomerModel} = require('../models')

class Customer {
  constructor(model) {
    this.model = model
  }

  async findAll(where = {}) {
    return await this.model.findAll(where)
  }

  async findOne(customerNumber) {
    return await this.model.findOne({
      where: {
        customerNumber: customerNumber
      }
    })
  }

  async updateOne(customerNumber, input) {
    await this.model.update(input, {
      where: {
        customerNumber: customerNumber
      }
    })
    
    return this.findOne(customerNumber)
  }
}

module.exports = new Customer(CustomerModel)